import { Context } from "oc-template-typescript-react-compiler";
import { AdditionalData, ClientProps, OcParameters } from "./types";

export async function data(
  context: Context<OcParameters>,
  callback: (error: any, data: ClientProps | AdditionalData) => void
) {
  return callback(null, {});
}
