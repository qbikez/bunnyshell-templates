import { Context } from "oc-template-typescript-react-compiler";
import { ClientProps, OcParameters } from "./types";

export async function data(
  context: Context<OcParameters>,
  callback: (error: any, data: ClientProps) => void
) {
  return callback(null, { paymentsUrl: "http://localhost:5000" });
}
