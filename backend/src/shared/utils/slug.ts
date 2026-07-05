/**
 * Generates a URL-friendly slug from a text string.
 * It removes accents, converts to lowercase, replaces spaces/non-alphanumeric characters with dashes.
 *
 * @param text - The input string (e.g. "Polo de Algodón")
 * @returns The slugified string (e.g. "polo-de-algodon")
 */
export function generateSlug(text: string): string {
  return text
    .toLowerCase()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "") // Remove accents/diacritics
    .replace(/[^a-z0-9\s-]/g, "") // Remove non-alphanumeric chars
    .trim()
    .replace(/\s+/g, "-") // Replace spaces with single dash
    .replace(/-+/g, "-"); // Collapse multiple dashes
}
