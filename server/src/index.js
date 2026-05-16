import { Hono } from 'hono'
import { cors } from 'hono/cors'
import { logger } from 'hono/logger'

const app = new Hono()

// ==================== Middleware ====================

app.use('*', cors())
app.use('*', logger())

// Auth middleware for admin routes
async function adminAuth(c, next) {
  const token = c.req.header('x-admin-token')
  if (token !== c.env.ADMIN_TOKEN) {
    return c.json({ error: 'Unauthorized' }, 401)
  }
  await next()
}

// ==================== Health ====================

app.get('/api/health', (c) => {
  return c.json({ status: 'ok', service: 'knowchina-server', timestamp: new Date().toISOString() })
})

// ==================== Briefings (Public) ====================

// GET /api/briefing/latest — today's briefing (free: titles only, pro: full)
app.get('/api/briefing/latest', async (c) => {
  // const supabase = createClient(c.env.SUPABASE_URL, c.env.SUPABASE_ANON_KEY)
  // const userId = c.req.header('x-user-id')
  // const isPro = await checkProStatus(userId, c.env.REVENUECAT_API_KEY)
  return c.json({ message: 'Briefing endpoint — coming soon' })
})

// GET /api/briefing/:date — historical briefing (Pro only)
app.get('/api/briefing/:date', async (c) => {
  return c.json({ message: 'Historical briefing — coming soon' })
})

// ==================== Archive ====================

// GET /api/archive — list all archive articles
app.get('/api/archive', async (c) => {
  return c.json({ message: 'Archive listing — coming soon' })
})

// GET /api/archive/:slug — single article (free: preview, pro: full)
app.get('/api/archive/:slug', async (c) => {
  return c.json({ message: 'Archive article — coming soon' })
})

// ==================== Data Card ====================

// GET /api/data/today — today's data card
app.get('/api/data/today', async (c) => {
  return c.json({ message: 'Today data — coming soon' })
})

// GET /api/data/history — historical data (Pro only)
app.get('/api/data/history', async (c) => {
  return c.json({ message: 'Data history — coming soon' })
})

// ==================== Knowledge ====================

// GET /api/knowledge/:keyword — deep-dive (free: short def, pro: full)
app.get('/api/knowledge/:keyword', async (c) => {
  return c.json({ message: 'Knowledge deep-dive — coming soon' })
})

// ==================== Admin (Protected) ====================

// POST /api/admin/generate — trigger AI briefing generation
app.post('/api/admin/generate', adminAuth, async (c) => {
  // 1. Fetch RSS sources
  // 2. Call OpenAI/Claude to generate briefing
  // 3. Extract knowledge keywords
  // 4. Generate knowledge deep-dive content
  // 5. Save to Supabase as draft
  return c.json({ message: 'Briefing generation triggered — implementation pending' })
})

// POST /api/admin/publish — publish a drafted briefing
app.post('/api/admin/publish', adminAuth, async (c) => {
  return c.json({ message: 'Briefing published — implementation pending' })
})

// ==================== Webhooks ====================

// POST /api/webhook/revenuecat — RevenueCat subscription events
app.post('/api/webhook/revenuecat', async (c) => {
  // Handle subscription status changes, sync with Supabase user table
  return c.json({ received: true })
})

// ==================== Cron (Daily Briefing) ====================

// Called by Cloudflare Cron Trigger — generates and auto-publishes daily briefing
app.get('/api/cron/daily-briefing', async (c) => {
  // Verify cron secret to prevent external access
  const cronSecret = c.req.header('x-cron-secret')
  if (cronSecret !== c.env.CRON_SECRET) {
    return c.json({ error: 'Unauthorized' }, 401)
  }
  // Same logic as /api/admin/generate but auto-publish
  return c.json({ message: 'Cron briefing generation — implementation pending' })
})

// ==================== Not Found ====================

app.notFound((c) => c.json({ error: 'Not Found' }, 404))

export default app
