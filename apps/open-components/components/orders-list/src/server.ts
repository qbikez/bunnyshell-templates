import { Context } from "oc-template-typescript-react-compiler";
import { ClientProps, OcParameters } from "./types";

export async function data(
  context: Context<OcParameters>,
  callback: (error: any, data: ClientProps) => void
) {
  const ordersUrl =
    context.env.name === "production" ? "" : "http://localhost:5223";
  return callback(null, { ordersUrl });
}

