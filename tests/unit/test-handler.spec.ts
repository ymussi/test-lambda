import * as app from "../../app";
import { EventBodyType } from "../../src/interfaces/eventBodyType";
import { ResponseBodyType } from "../../src/interfaces/responseBodyType";
const event: EventBodyType = {
  accessToken: "12345678900",
  preferred_username: "12345678900",
};

describe("Tests app", () => {
  it("Verifies successful response", async () => {
    await app.handler(event).then((data: ResponseBodyType) => {
      expect(data).toHaveProperty("body.message");
      expect(data).not.toBeInstanceOf(Error);
    });
  });
});
