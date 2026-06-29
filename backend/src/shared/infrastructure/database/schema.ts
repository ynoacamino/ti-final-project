import { sqliteTable, text, integer, index, uniqueIndex } from "drizzle-orm/sqlite-core";
import { sql } from "drizzle-orm";

// 1. users
export const users = sqliteTable(
  "users",
  {
    id: text("id").primaryKey(),
    email: text("email").unique().notNull(),
    passwordHash: text("password_hash").notNull(),
    name: text("name").notNull(),
    phone: text("phone"),
    role: text("role").notNull(), // 'admin', 'customer'
    defaultShippingAddress: text("default_shipping_address"),
    isActive: integer("is_active").notNull().default(1), // boolean 0 or 1
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
    updatedAt: text("updated_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
  },
  (table) => ({
    roleIdx: index("idx_users_role").on(table.role),
  }),
);

// 2. categories
export const categories = sqliteTable("categories", {
  id: text("id").primaryKey(),
  name: text("name").unique().notNull(),
  slug: text("slug").unique().notNull(),
  description: text("description"),
  isActive: integer("is_active").notNull().default(1),
  createdAt: text("created_at")
    .notNull()
    .default(sql`CURRENT_TIMESTAMP`),
  updatedAt: text("updated_at")
    .notNull()
    .default(sql`CURRENT_TIMESTAMP`),
});

// 3. products
export const products = sqliteTable(
  "products",
  {
    id: text("id").primaryKey(),
    name: text("name").notNull(),
    slug: text("slug").unique().notNull(),
    description: text("description"),
    basePrice: integer("base_price").notNull(), // in cents
    categoryId: text("category_id")
      .notNull()
      .references(() => categories.id, { onDelete: "restrict" }),
    isActive: integer("is_active").notNull().default(1),
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
    updatedAt: text("updated_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
  },
  (table) => ({
    categoryActiveIdx: index("idx_products_category_active").on(table.categoryId, table.isActive),
    nameIdx: index("idx_products_name").on(table.name),
  }),
);

// 4. product_variants
export const productVariants = sqliteTable(
  "product_variants",
  {
    id: text("id").primaryKey(),
    productId: text("product_id")
      .notNull()
      .references(() => products.id, { onDelete: "cascade" }),
    size: text("size").notNull(),
    color: text("color").notNull(),
    sku: text("sku").unique().notNull(),
    stock: integer("stock").notNull().default(0),
    additionalPrice: integer("additional_price").notNull().default(0), // in cents
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
    updatedAt: text("updated_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
  },
  (table) => ({
    skuIdx: uniqueIndex("uq_product_variants_sku").on(table.sku),
    comboIdx: uniqueIndex("uq_product_variants_combo").on(table.productId, table.size, table.color),
  }),
);

// 5. product_images
export const productImages = sqliteTable(
  "product_images",
  {
    id: text("id").primaryKey(),
    productId: text("product_id")
      .notNull()
      .references(() => products.id, { onDelete: "cascade" }),
    url: text("url").notNull(),
    position: integer("position").notNull().default(0),
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
  },
  (table) => ({
    productPosIdx: index("idx_product_images_product_pos").on(table.productId, table.position),
  }),
);

// 6. carts
export const carts = sqliteTable(
  "carts",
  {
    id: text("id").primaryKey(),
    customerId: text("customer_id").references(() => users.id, { onDelete: "cascade" }),
    sessionId: text("session_id"),
    status: text("status").notNull().default("active"), // 'active', 'abandoned', 'converted'
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
    updatedAt: text("updated_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
  },
  (table) => ({
    customerIdx: index("idx_carts_customer").on(table.customerId),
    sessionIdx: index("idx_carts_session").on(table.sessionId),
    statusIdx: index("idx_carts_status").on(table.status),
  }),
);

// 7. cart_items
export const cartItems = sqliteTable(
  "cart_items",
  {
    id: text("id").primaryKey(),
    cartId: text("cart_id")
      .notNull()
      .references(() => carts.id, { onDelete: "cascade" }),
    productVariantId: text("product_variant_id")
      .notNull()
      .references(() => productVariants.id, { onDelete: "restrict" }),
    quantity: integer("quantity").notNull().default(1),
    unitPriceSnapshot: integer("unit_price_snapshot").notNull(), // in cents
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
    updatedAt: text("updated_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
  },
  (table) => ({
    cartVariantIdx: uniqueIndex("uq_cart_items_cart_variant").on(
      table.cartId,
      table.productVariantId,
    ),
    cartIdx: index("idx_cart_items_cart").on(table.cartId),
  }),
);

// 8. orders
export const orders = sqliteTable(
  "orders",
  {
    id: text("id").primaryKey(),
    customerId: text("customer_id").references(() => users.id, { onDelete: "set null" }),
    guestEmail: text("guest_email"),
    guestName: text("guest_name"),
    guestPhone: text("guest_phone"),
    shippingAddress: text("shipping_address"), // JSON text
    subtotal: integer("subtotal").notNull(), // in cents
    total: integer("total").notNull(), // in cents
    currency: text("currency").notNull().default("PEN"), // 'PEN', 'USD'
    status: text("status").notNull().default("pendiente"), // 'pendiente', 'pagado', 'enviado', 'entregado', 'cancelado', 'fallido'
    stripePaymentIntentId: text("stripe_payment_intent_id").unique(),
    notes: text("notes"),
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
    updatedAt: text("updated_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
  },
  (table) => ({
    customerCreatedIdx: index("idx_orders_customer_created").on(table.customerId, table.createdAt),
    statusCreatedIdx: index("idx_orders_status_created").on(table.status, table.createdAt),
    guestEmailIdx: index("idx_orders_guest_email").on(table.guestEmail),
  }),
);

// 9. order_items
export const orderItems = sqliteTable(
  "order_items",
  {
    id: text("id").primaryKey(),
    orderId: text("order_id")
      .notNull()
      .references(() => orders.id, { onDelete: "cascade" }),
    productVariantId: text("product_variant_id")
      .notNull()
      .references(() => productVariants.id, { onDelete: "restrict" }),
    productNameSnapshot: text("product_name_snapshot").notNull(),
    variantDetailsSnapshot: text("variant_details_snapshot").notNull(), // JSON text for {size, color, sku}
    quantity: integer("quantity").notNull(),
    unitPrice: integer("unit_price").notNull(), // in cents
    subtotal: integer("subtotal").notNull(), // in cents
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
  },
  (table) => ({
    orderIdx: index("idx_order_items_order").on(table.orderId),
    variantIdx: index("idx_order_items_variant").on(table.productVariantId),
  }),
);

// 10. payments
export const payments = sqliteTable(
  "payments",
  {
    id: text("id").primaryKey(),
    orderId: text("order_id")
      .notNull()
      .references(() => orders.id, { onDelete: "cascade" }),
    amount: integer("amount").notNull(), // in cents
    currency: text("currency").notNull().default("PEN"),
    status: text("status").notNull(), // 'pending', 'succeeded', 'failed', 'refunded'
    method: text("method").notNull().default("card"), // 'card', 'yape', 'plin', 'cash'
    stripeChargeId: text("stripe_charge_id").unique(),
    stripePaymentIntentId: text("stripe_payment_intent_id"),
    errorMessage: text("error_message"),
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
    updatedAt: text("updated_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
  },
  (table) => ({
    orderIdx: index("idx_payments_order").on(table.orderId),
    statusIdx: index("idx_payments_status").on(table.status),
  }),
);

// 11. stock_movements
export const stockMovements = sqliteTable(
  "stock_movements",
  {
    id: text("id").primaryKey(),
    productVariantId: text("product_variant_id")
      .notNull()
      .references(() => productVariants.id, { onDelete: "cascade" }),
    type: text("type").notNull(), // 'sale', 'restock', 'adjustment', 'cancellation'
    quantity: integer("quantity").notNull(),
    previousStock: integer("previous_stock").notNull(),
    newStock: integer("new_stock").notNull(),
    referenceType: text("reference_type"), // 'order', 'manual', 'restock'
    referenceId: text("reference_id"),
    notes: text("notes"),
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
    createdBy: text("created_by").references(() => users.id, { onDelete: "set null" }),
  },
  (table) => ({
    variantCreatedIdx: index("idx_stock_movements_variant_created").on(
      table.productVariantId,
      table.createdAt,
    ),
    typeIdx: index("idx_stock_movements_type").on(table.type),
  }),
);

// 12. stock_alerts
export const stockAlerts = sqliteTable(
  "stock_alerts",
  {
    id: text("id").primaryKey(),
    productVariantId: text("product_variant_id")
      .notNull()
      .references(() => productVariants.id, { onDelete: "cascade" }),
    threshold: integer("threshold").notNull(),
    currentStock: integer("current_stock").notNull(),
    status: text("status").notNull().default("active"), // 'active', 'resolved'
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
    resolvedAt: text("resolved_at"),
  },
  (table) => ({
    statusCreatedIdx: index("idx_stock_alerts_status_created").on(table.status, table.createdAt),
    variantIdx: index("idx_stock_alerts_variant").on(table.productVariantId),
  }),
);

// 13. faqs
export const faqs = sqliteTable(
  "faqs",
  {
    id: text("id").primaryKey(),
    question: text("question").notNull(),
    answer: text("answer").notNull(),
    keywords: text("keywords").notNull(), // JSON text array of keywords
    category: text("category"),
    isActive: integer("is_active").notNull().default(1),
    createdAt: text("created_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
    updatedAt: text("updated_at")
      .notNull()
      .default(sql`CURRENT_TIMESTAMP`),
  },
  (table) => ({
    categoryIdx: index("idx_faqs_category").on(table.category),
    activeIdx: index("idx_faqs_active").on(table.isActive),
  }),
);
