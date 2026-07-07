export interface IStorageService {
  upload(
    fileBuffer: Buffer,
    fileName: string,
    contentType: string,
    origin?: string,
  ): Promise<string>;
  delete(fileUrl: string): Promise<void>;
}
