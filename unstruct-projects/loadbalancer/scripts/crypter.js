#!/usr/bin/env node

/* npm packages */
const fs = require("fs");

const crypto = require("crypto");

const algorithm = "aes-256-ctr";
const keyStr = fs.readFileSync("secretkey.txt");
const key = crypto.createHash("sha256").update(String(keyStr)).digest("base64").substring(0, 32);

const encrypt = (buffer) => {
  // Create an initialization vector
  const iv = crypto.randomBytes(16);
  // Create a new cipher using the algorithm, key, and iv
  const cipher = crypto.createCipheriv(algorithm, key, iv);
  // Create the new (encrypted) buffer
  const result = Buffer.concat([iv, cipher.update(buffer), cipher.final()]);
  return result;
};

const decrypt = (encrypted) => {
  // Get the iv: the first 16 bytes
  const iv = encrypted.slice(0, 16);
  // Get the rest
  const encryptedSliced = encrypted.slice(16);
  // Create a decipher
  const decipher = crypto.createDecipheriv(algorithm, key, iv);
  // Actually decrypt it
  const result = Buffer.concat([decipher.update(encryptedSliced), decipher.final()]);
  return result;
};

let action = "";
let srcFile = "";
let dstFile = "";

// node index.js encrypt ./abc.txt ./abc.txt.en
const args = process.argv.slice(2);
if (args.length < 3) {
  process.exit(1);
} else if (["encrypt", "decrypt"].includes(args[0]) === false) {
  process.exit(1);
} else {
  [action, srcFile, dstFile] = args;
}

let decStr; let
  encStr;
if (action === "encrypt") {
  const decContent = fs.readFileSync(srcFile);
  decStr = Buffer.from(decContent);

  encStr = encrypt(decStr);
  console.log("Encrypted:", encStr.toString());

  fs.writeFile(dstFile, encStr, (err) => {
    if (err) console.log(err);
  });
} else if (action === "decrypt") {
  const encContent = fs.readFileSync(srcFile);
  encStr = Buffer.from(encContent);

  decStr = decrypt(encStr);
  console.log("Decrypted:", decStr.toString());

  fs.writeFile(dstFile, decStr, (err) => {
    if (err) console.log(err);
  });
}
