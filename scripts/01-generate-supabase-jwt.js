const crypto = require("crypto");

// Get the JWT secret from Terraform output or AWS Secrets Manager
const JWT_SECRET = "...";
const ENVIRONMENT = "development";

function base64urlEncode(str) {
	return Buffer.from(str).toString("base64").replace(/\+/g, "-").replace(/\//g, "_").replace(/=/g, "");
}

function generateJWT(payload, secret) {
	const header = { alg: "HS256", typ: "JWT" };

	const encodedHeader = base64urlEncode(JSON.stringify(header));
	const encodedPayload = base64urlEncode(JSON.stringify(payload));

	const signature = crypto.createHmac("sha256", secret).update(`$${encodedHeader}.$${encodedPayload}`).digest("base64").replace(/\+/g, "-").replace(/\//g, "_").replace(/=/g, "");

	return `$${encodedHeader}.$${encodedPayload}.$${signature}`;
}

// Generate anon key
const anonPayload = {
	iss: "supabase",
	ref: `lookcard-$${ENVIRONMENT}`,
	role: "anon",
	iat: Math.floor(Date.now() / 1000),
	exp: Math.floor(Date.now() / 1000) + 365 * 24 * 60 * 60, // 1 year
};

// Generate service role key
const servicePayload = {
	iss: "supabase",
	ref: `lookcard-$${ENVIRONMENT}`,
	role: "service_role",
	iat: Math.floor(Date.now() / 1000),
	exp: Math.floor(Date.now() / 1000) + 365 * 24 * 60 * 60, // 1 year
};

const anonKey = generateJWT(anonPayload, JWT_SECRET);
const serviceRoleKey = generateJWT(servicePayload, JWT_SECRET);

console.log("Anon Key:", anonKey);
console.log("Service Role Key:", serviceRoleKey);

// Update AWS secret with generated tokens
const secretData = {
	database_url: "postgresql://...", // from existing secret
	jwt_secret: JWT_SECRET,
	anon_key: anonKey,
	service_role_key: serviceRoleKey,
};

console.log(JSON.stringify(secretData, null, 2));
