const baseUrl = Cypress.env("baseUrl");

describe("e2e", () => {
  beforeEach(() => {
    cy.visit(baseUrl);
    cy.intercept("POST", "**/pay").as("pay");
  });
  describe("when order clicked", () => {
    let orderId: string;
    beforeEach(() => {
        cy.get('[data-testid="btn-place-order"]').click();
        cy.wait("@pay").then((interception) => {
            expect(interception.request.body).to.have.property("orderId");
            orderId = interception.request.body.orderId;
        });
    });
    it("order is added to the list", () => {
        cy.get('[data-testid="order-list"]').contains(orderId);
    });
  });
});
