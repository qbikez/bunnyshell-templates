import { Context } from "oc-template-typescript-react-compiler";
import { ClientProps, OcParameters } from "./types";

export async function data(
  context: Context<OcParameters>,
  callback: (error: any, data: ClientProps) => void
) {
  const paymentsUrl =
    context.env.name === "production" ? "" : "http://localhost:5000";
  return callback(null, { paymentsUrl });
}
