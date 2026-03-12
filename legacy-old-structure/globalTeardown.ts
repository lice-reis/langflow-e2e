// tests/globalTeardown.ts
// No-op: in standalone mode, Langflow is started externally (Docker/pip).
// There is no local temp database to clean up.
export default async () => {
  console.log("Global teardown complete (standalone mode — no local server to clean up).");
};
