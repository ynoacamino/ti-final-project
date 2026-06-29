import { db } from "./client.ts";
import { users, categories, products, productVariants, productImages } from "./schema.ts";
import { generateSlug } from "../../utils/slug.ts";
import bcrypt from "bcrypt";

async function main() {
  console.log("🌱 Starting database seeding...");

  // 1. Seed Admin User
  const adminEmail = "admin@smartpyme.com";
  const [existingAdmin] = await db.select().from(users).where(eq(users.email, adminEmail)).limit(1);

  if (!existingAdmin) {
    const passwordHash = await bcrypt.hash("admin123456", 10);
    await db.insert(users).values({
      id: crypto.randomUUID(),
      email: adminEmail,
      passwordHash,
      name: "Alvaro Quispe (Admin)",
      role: "admin",
      isActive: 1,
    });
    console.log("✅ Admin user created: admin@smartpyme.com / admin123456");
  } else {
    console.log("ℹ️ Admin user already exists");
  }

  // 2. Seed Categories
  const categoryTemplates = [
    { name: "Camisas", description: "Camisas casuales y elegantes para toda ocasión" },
    { name: "Jeans", description: "Jeans duraderos en cortes clásicos y modernos" },
    { name: "Vestidos", description: "Vestidos de temporada con diseños exclusivos" },
    { name: "Accesorios", description: "Complementos ideales para tu outfit cotidiano" },
  ];

  const catIdMap = new Map<string, string>();

  for (const cat of categoryTemplates) {
    const slug = generateSlug(cat.name);
    const [existingCat] = await db
      .select()
      .from(categories)
      .where(eq(categories.slug, slug))
      .limit(1);

    let catId = existingCat?.id;
    if (!existingCat) {
      catId = crypto.randomUUID();
      await db.insert(categories).values({
        id: catId,
        name: cat.name,
        slug,
        description: cat.description,
        isActive: 1,
      });
      console.log(`✅ Category created: ${cat.name}`);
    } else {
      console.log(`ℹ️ Category already exists: ${cat.name}`);
    }
    catIdMap.set(cat.name, catId!);
  }

  // 3. Seed Products, Variants, and Images (Idempotent: run only if products are empty)
  const [existingProducts] = await db.select({ count: sql`count(*)` }).from(products);
  const productCount = Number(existingProducts?.count || 0);

  if (productCount === 0) {
    const productTemplates = [
      // Camisas
      {
        category: "Camisas",
        name: "Camisa Oxford Azul",
        description: "Camisa oxford clásica de algodón 100% transpirable.",
        basePrice: 4990, // S/. 49.90
        variants: [
          { size: "S", color: "Azul", sku: "CMS-OXF-S-BLU", stock: 15 },
          { size: "M", color: "Azul", sku: "CMS-OXF-M-BLU", stock: 20 },
          { size: "L", color: "Azul", sku: "CMS-OXF-L-BLU", stock: 8 },
        ],
        imageUrl: "https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500",
      },
      {
        category: "Camisas",
        name: "Camisa Lino Blanca",
        description: "Camisa de lino ligera, perfecta para climas cálidos.",
        basePrice: 5990,
        variants: [
          { size: "M", color: "Blanco", sku: "CMS-LIN-M-WHT", stock: 12 },
          { size: "L", color: "Blanco", sku: "CMS-LIN-L-WHT", stock: 10 },
        ],
        imageUrl: "https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=500",
      },
      {
        category: "Camisas",
        name: "Camisa Denim Casual",
        description: "Camisa de jean clásica con lavado medio.",
        basePrice: 6990,
        variants: [
          { size: "S", color: "Denim", sku: "CMS-DNM-S-MED", stock: 7 },
          { size: "M", color: "Denim", sku: "CMS-DNM-M-MED", stock: 14 },
        ],
        imageUrl: "https://images.unsplash.com/photo-1576566588028-4147f3842f27?w=500",
      },
      // Jeans
      {
        category: "Jeans",
        name: "Jean Slim Fit Negro",
        description: "Jeans de corte entallado y tejido elástico confort.",
        basePrice: 7990,
        variants: [
          { size: "30", color: "Negro", sku: "JNS-SLM-30-BLK", stock: 18 },
          { size: "32", color: "Negro", sku: "JNS-SLM-32-BLK", stock: 25 },
          { size: "34", color: "Negro", sku: "JNS-SLM-34-BLK", stock: 15 },
        ],
        imageUrl: "https://images.unsplash.com/photo-1542272604-787c3835535d?w=500",
      },
      {
        category: "Jeans",
        name: "Jean Regular Wash",
        description: "Jeans clásicos de corte recto en mezclilla prelavada.",
        basePrice: 6990,
        variants: [
          { size: "32", color: "Azul", sku: "JNS-REG-32-BLU", stock: 9 },
          { size: "34", color: "Azul", sku: "JNS-REG-34-BLU", stock: 4 }, // Triggers low-stock alert!
        ],
        imageUrl: "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=500",
      },
      // Vestidos
      {
        category: "Vestidos",
        name: "Vestido Floral de Verano",
        description: "Vestido corto con estampado floral y tirantes ajustables.",
        basePrice: 8990,
        variants: [
          { size: "S", color: "Floral", sku: "VES-FLO-S-FLR", stock: 11 },
          { size: "M", color: "Floral", sku: "VES-FLO-M-FLR", stock: 15 },
        ],
        imageUrl: "https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500",
      },
      {
        category: "Vestidos",
        name: "Vestido de Noche Elegante",
        description: "Vestido largo de fiesta color negro satinado.",
        basePrice: 14990,
        variants: [
          { size: "S", color: "Negro", sku: "VES-NCH-S-BLK", stock: 5 },
          { size: "M", color: "Negro", sku: "VES-NCH-M-BLK", stock: 6 },
        ],
        imageUrl: "https://images.unsplash.com/photo-1566174053879-31528523f8ae?w=500",
      },
      // Accesorios
      {
        category: "Accesorios",
        name: "Cinturón de Cuero Marrón",
        description: "Cinturón fabricado en cuero genuino con hebilla metálica.",
        basePrice: 3500,
        variants: [
          { size: "M", color: "Marrón", sku: "ACC-CIN-M-BRN", stock: 30 },
          { size: "L", color: "Marrón", sku: "ACC-CIN-L-BRN", stock: 25 },
        ],
        imageUrl: "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500",
      },
      {
        category: "Accesorios",
        name: "Gorra Deportiva Negra",
        description: "Gorra de algodón con visera curva y correa ajustable.",
        basePrice: 2500,
        variants: [{ size: "Única", color: "Negro", sku: "ACC-GOR-UNI-BLK", stock: 40 }],
        imageUrl: "https://images.unsplash.com/photo-1588850561407-ed78c282e89b?w=500",
      },
    ];

    for (const prod of productTemplates) {
      const categoryId = catIdMap.get(prod.category)!;
      const slug = generateSlug(prod.name);
      const productId = crypto.randomUUID();

      // Insert Product
      await db.insert(products).values({
        id: productId,
        name: prod.name,
        slug,
        description: prod.description,
        basePrice: prod.basePrice,
        categoryId,
        isActive: 1,
      });

      // Insert Variants
      for (const v of prod.variants) {
        await db.insert(productVariants).values({
          id: crypto.randomUUID(),
          productId,
          size: v.size,
          color: v.color,
          sku: v.sku,
          stock: v.stock,
          additionalPrice: 0,
        });
      }

      // Insert Image Link
      await db.insert(productImages).values({
        id: crypto.randomUUID(),
        productId,
        url: prod.imageUrl,
        position: 0,
      });

      console.log(`✅ Product & variants seeded: ${prod.name}`);
    }
  } else {
    console.log("ℹ️ Products already seeded");
  }

  console.log("🌱 Seeding finished successfully!");
  process.exit(0);
}

import { eq, sql } from "drizzle-orm";

main().catch((err) => {
  console.error("❌ Seeding failed:", err);
  process.exit(1);
});
