"use client"

import { authClient } from "@workspace/auth/client"
import { useState } from "react"

import { Button } from "@workspace/ui/components/button"
import { Google } from "@/components/icons"

export default function Page() {
  const [pending, setPending] = useState(false)
  async function signInWithGoogle() {
    setPending(true)
    await authClient.signIn.social({
      provider: "google",
    })
  }
  return (
    <div className="flex min-h-screen items-center justify-center">
      <div className="flex w-full max-w-sm flex-col items-center">

        <h1 className="text-3xl font-semibold mb-5">Bubbly</h1>

        <Button
          disabled={pending}
          size="lg"
          className="w-full"
          variant="outline"
          onClick={() => signInWithGoogle()}
        >
          <Google />
          Sign in with Google
        </Button>
      </div>
    </div>
  )
}