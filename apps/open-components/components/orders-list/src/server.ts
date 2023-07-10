import { Context } from "oc-template-typescript-react-compiler";
import { ClientProps, OcParameters } from "./types";

export async function data(
  context: Context<OcParameters>,
  callback: (error: any, data: ClientProps) => void
) {
  return callback(null, { ordersUrl: "http://localhost:5223" });
}
