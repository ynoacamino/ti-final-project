import { S3Client, PutObjectCommand, DeleteObjectCommand } from "@aws-sdk/client-s3";
import type { IStorageService } from "../ports/out/IStorageService.ts";
import * as fs from "fs";
import * as path from "path";

/**
 *
 */
export class StorageService implements IStorageService {
  private s3Client: S3Client | null = null;
  private bucketName: string;
  private isMock = true;

  /**
   *
   */
  constructor() {
    this.bucketName = process.env.R2_BUCKET_NAME || "smartpyme-images";

    const accessKeyId = process.env.R2_ACCESS_KEY_ID;
    const secretAccessKey = process.env.R2_SECRET_ACCESS_KEY;
    const endpoint = process.env.R2_ENDPOINT;

    // Check if we should use mock/local storage instead of S3
    if (
      accessKeyId &&
      accessKeyId !== "mock_r2_access_key" &&
      secretAccessKey &&
      secretAccessKey !== "mock_r2_secret_key" &&
      endpoint
    ) {
      this.isMock = false;
      this.s3Client = new S3Client({
        region: "auto",
        endpoint,
        credentials: {
          accessKeyId,
          secretAccessKey,
        },
      });
    }
  }

  /**
   *
   */
  async upload(
    fileBuffer: Buffer,
    fileName: string,
    contentType: string,
    origin?: string,
  ): Promise<string> {
    if (this.isMock) {
      // Local fallback storage
      const relativePath = path.join("public", "uploads", fileName);
      const fullPath = path.join(process.cwd(), relativePath);

      // Ensure directory exists
      fs.mkdirSync(path.dirname(fullPath), { recursive: true });

      // Save buffer to file
      fs.writeFileSync(fullPath, fileBuffer);

      // Return local URL with dynamically provided origin or default localhost
      const baseOrigin = origin || `http://localhost:${process.env.PORT || 3000}`;
      return `${baseOrigin}/uploads/${fileName}`;
    }

    // Cloudflare R2 Upload
    const command = new PutObjectCommand({
      Bucket: this.bucketName,
      Key: fileName,
      Body: fileBuffer,
      ContentType: contentType,
    });

    await this.s3Client!.send(command);

    // Compute public URL
    // e.g. R2 endpoint: https://<accountid>.r2.cloudflarestorage.com
    // Usually, public bucket access is configured on a custom domain, but for reference:
    const customDomain = process.env.R2_CUSTOM_DOMAIN;
    if (customDomain) {
      return `${customDomain}/${fileName}`;
    }

    return `${process.env.R2_ENDPOINT}/${this.bucketName}/${fileName}`;
  }

  /**
   *
   */
  async delete(fileUrl: string): Promise<void> {
    if (this.isMock) {
      // Parse fileName from local URL
      const parts = fileUrl.split("/uploads/");
      const fileName = parts[1];
      if (fileName) {
        const fullPath = path.join(process.cwd(), "public", "uploads", fileName);
        if (fs.existsSync(fullPath)) {
          fs.unlinkSync(fullPath);
        }
      }
      return;
    }

    // Parse R2 key from URL
    const key = fileUrl.split("/").slice(4).join("/"); // assuming endpoint/bucket/key
    const command = new DeleteObjectCommand({
      Bucket: this.bucketName,
      Key: key,
    });

    await this.s3Client!.send(command);
  }
}
