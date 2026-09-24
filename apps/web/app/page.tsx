"use client";

import { Button } from "@workspace/ui/components/button";
import { authClient } from "@workspace/auth/client"
import { useRouter } from "next/navigation";

export default function Page() {
  const { data: session } = authClient.useSession();
  const router = useRouter();

  return (
    <div className="flex min-h-svh p-6">
      <div className="flex max-w-md min-w-0 flex-col gap-4 text-sm leading-loose">
        <div>
          <h1 className="font-medium">{session?.user?.name || "not signed in"}</h1>
          <Button onClick={() => router.push("/auth/login")} className="mt-2">sign in</Button>
        </div>
        <div className="text-muted-foreground font-mono text-xs">
          (Press <kbd>d</kbd> to toggle dark mode)
        </div>
      </div>
    </div>
  );
}
