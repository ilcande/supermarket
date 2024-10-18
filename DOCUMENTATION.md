# Supermarket Checkout Solution Design

## 1. Overview

This solution addresses the supermarket's requirement to scan items, apply pricing rules, and calculate total prices with discounts. The system is built in a way that accommodates future additions of new discount strategies, while also ensuring that it is maintainable and easily understandable for future developers.

The focus is on providing a **PORO** solution, avoiding unnecessary dependencies like Rails or a database. We adhered to key object-oriented design principles, keeping the system modular, extensible, and easy to test.

---

## 2. Design Choices

### Factory Pattern for Discount Strategies

The most significant design choice is the use of a **Factory Pattern** to handle the creation of discount strategies. By encapsulating the logic for discount creation in the `DiscountFactory` class, we are adhering to the **Open/Closed Principle** (OCP) from SOLID principles, ensuring that:

- The system is **open to extension**: New discount types can be added by creating new classes and modifying the factory, without altering the existing checkout or item logic.
- The system is **closed to modification**: Existing functionality is not affected when new discounts are introduced.

#### Why the Factory Pattern?

This pattern allows the system to easily introduce new discount types in the future. Right now, the supermarket only needs a bulk purchase discount, but this design enables straightforward expansion to other discount types (e.g., "Buy One Get One Free," "Percentage Discounts," etc.). The factory will be expanded using a switch-case or a strategy registry, depending on future requirements.

### Single Responsibility and Clean Abstractions

We aimed for clean abstractions by:

- Separating the concerns of **checkout** (scanning and calculating total) from **discounting** (applying specific discount rules).
- Each class handles a distinct responsibility:
  - `Checkout` class manages items and total calculation.
  - `DiscountFactory` is responsible for creating the correct discount objects.
  - `BulkPurchaseDiscount` encapsulates the specific logic for applying bulk purchase discounts.

#### Benefits for New Developers

New developers will find the code easy to navigate because:

- **Well-defined responsibilities**: Each class has a clear responsibility, making it easier to understand the role of each part of the system.
- **Easily identifiable extension points**: When new discounts are required, it is clear that they can be added in the factory without touching the `Checkout` or `Item` classes.
- **Testing simplicity**: Each class can be unit tested in isolation, ensuring any changes to discount logic can be easily validated without affecting unrelated parts of the system.

### Guard Clause for Error Handling

We used a **guard clause** in `DiscountFactory` to raise an exception if an unsupported discount type is provided. This ensures that the system is **fail-fast**, making it easier to identify errors early during development or testing.

While the guard clause is used now (since we only have one discount type), it can be replaced with a more robust pattern such as a case-switch statement when more discount strategies are introduced. 

---

## 3. Future-Proofing the System

The system was designed with future expansion in mind, specifically for adding new discount types. Below are the steps and strategies that future developers can follow to add a new discount:

1. **Add a New Discount Class**:
   - Each new discount type should have its own class that implements the logic for applying that discount. The new class should inherit from a common interface or base class, if necessary, for common behavior.

2. **Update the DiscountFactory**:
   - The `DiscountFactory` is designed to be the single place where discount objects are created. New discounts can be added by modifying the factory to return instances of new discount classes based on the pricing rules passed to it.

3. **Minimal Changes to Checkout**:
   - The `Checkout` class remains largely unchanged regardless of the number of discount types added. This adheres to the **Open/Closed Principle**, making the system easy to maintain as new features are added.

4. **Testing Framework**:
   - Tests should be created or updated for each new discount type, ensuring that edge cases and expected behavior are covered. The modular design ensures that adding new tests for discount classes can be done independently of the checkout process.

---

## 4. Trade-offs and Design Considerations

### Trade-offs

- **Simplified Data Handling**: We opted to keep the solution as a PORO-based system without a database, which simplifies the initial implementation but may limit scaling in the future if more complex data persistence is needed. For now, the PORO model works well for the supermarket’s needs and aligns with requirements.
  
- **Manual Discount Management**: Currently, pricing rules are passed into the checkout class. This approach allows for flexibility in testing but assumes that an external system will handle the management of these pricing rules. Future implementations could include a rules management system.

### Areas for Potential Improvement

- **New Discount Types**: As mentioned, we’ve planned for the future introduction of new discounts. The factory pattern used in `DiscountFactory` is the ideal place to extend this logic. Should the range of discounts grow significantly, it may be worth considering a **Strategy Pattern** to handle different types of discounts.
  
- **Complex Pricing Rules**: For now, we assume simple bulk discount rules, but if future discounts become more complex (e.g., conditional discounts based on customer types or time of purchase), the `Checkout` class may need to interact with more complex pricing engines.

---

## 5. Testing Strategy

We have employed **RSpec** to ensure that the code is thoroughly tested. Unit tests are provided for:

- Scanning items and calculating totals with and without discounts.
- Applying discounts correctly based on pricing rules.
- Validating the behavior of the factory when correct or incorrect discount rules are provided.

### Test Coverage

- **Factory Pattern**: We test both the success case (valid discount) and failure case (unsupported discount).
- **Bulk Purchase Discount**: We test various scenarios, such as having the exact number of items for a discount, having extra items, and having fewer items than needed for the discount.

### Test-Driven Development

The solution was developed using TDD principles. Commits were made after implementing each feature or resolving an issue, ensuring that development decisions are visible and traceable.

---

## 6. Running the Application and Tests

To run the application and calculate basket totals or run the tests, follow these steps:

### 6.1 Install Dependencies

Make sure you have all necessary dependencies by running the following command:

```bash
bundle install
```

### 6.2 Running the Application

To run the application and calculate the total price of items in a basket, use the following command:

```bash
ruby lib/app.rb
```

This will launch the application, allowing you to scan items, apply pricing rules, and calculate total prices with discounts.

### 6.3 Running the Tests

To run the RSpec tests, use the following command:

```bash
bundle exec rspec
```

This will execute all the test cases to ensure the solution is functioning correctly.

## 7. Conclusion

The solution is designed to be modular, extensible, and maintainable. By using design patterns like the factory pattern and adhering to SOLID principles, we’ve ensured that future developers can add new features (e.g., new discount types) with minimal changes to the existing system. Our testing strategy ensures that the code remains reliable and robust as new features are added.

This approach provides a balance between simplicity and future scalability, allowing the supermarket to meet its current needs while preparing for future growth.
