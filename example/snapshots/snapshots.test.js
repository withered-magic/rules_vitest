import { expect, it } from "vitest";

it("toUpperCase", () => {
  const result = "foobar".toUpperCase();
  expect(result).toMatchSnapshot();
});
