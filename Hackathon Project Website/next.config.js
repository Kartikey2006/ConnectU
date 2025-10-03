/** @type {import('next').NextConfig} */
const nextConfig = {
  ...(process.env.NODE_ENV === 'production' && { output: 'export' }),
  trailingSlash: true,
  ...(process.env.NODE_ENV === 'production' && { distDir: 'out' }),
  eslint: {
    ignoreDuringBuilds: true,
  },
  images: {
    unoptimized: true,
    domains: ['cudwwhohzfxmflquizhk.supabase.co'],
  },
}

module.exports = nextConfig
