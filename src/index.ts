import { Hono } from "hono";
import { BlankInput } from "hono/types";

const app = new Hono();

app.get("/", (c) => {
	return c.text("Hello Hono!");
});

app.get("/customers", (c) => {
	return c.json([{ id: 1, name: "something" }]);
});

export default app;
