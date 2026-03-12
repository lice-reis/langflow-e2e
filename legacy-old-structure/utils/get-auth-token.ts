import type { APIRequestContext } from "@playwright/test";

/**
 * Obtém token de autenticação do Langflow.
 * Em modo auto_login (padrão), usa /api/v1/auto_login.
 * Retorna o header Authorization pronto para uso.
 */
export async function getAuthToken(request: APIRequestContext): Promise<string> {
  const res = await request.get("/api/v1/auto_login");

  if (res.ok()) {
    const body = await res.json();
    if (body?.access_token) {
      return `Bearer ${body.access_token}`;
    }
  }

  // fallback: sem token (ambiente sem auth)
  return "";
}
