import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  transpilePackages: ["@workspace/ui", "@workspace/auth", "@workspace/db", "@workspace/env"],
  output: "standalone",
};

export default nextConfig;
