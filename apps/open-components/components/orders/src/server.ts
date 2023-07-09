import { Context } from "oc-template-typescript-react-compiler";
import { AdditionalData, ClientProps, OcParameters } from "./types";

const database = [
  { name: "John Doe", age: 34, hobbies: ["Swimming", "Basketball"] },
  { name: "Jane Doe", age: 35, hobbies: ["Running", "Rugby"] },
];

async function getUser(userId: number) {
  return database[userId];
}

export async function data(
  context: Context<OcParameters>,
  callback: (error: any, data: ClientProps | AdditionalData) => void
) {
  return callback(null, {});
}
