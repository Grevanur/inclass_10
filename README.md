# Cosmic Guild Signup — In-Class Activity 10

## Submission information

- Track: Graduate
- Completed tasks: Task A (Local Signup Tip Simulation) + Task B (Password Coach)
- Student: Gowtham Revanur
- Partner: **[Add partner's full name before submission]**
- Repository: https://github.com/Grevanur/inclass_10
- Local tip category: `password_help`

## What the app does

The app validates name, email, and password fields before showing a green success message. Task A stores three short `password_help` tips inside the app, simulates a brief loading state, labels every result as preset demo content, and includes a repeatable missing-data error with retry. The tip feature does not read the name, email, or password and makes no network request. Task B evaluates only password length on-device and shows three guidance states: empty, under eight characters, and at least eight characters.

## Transparent rules and boundaries

- Form validation remains separate from the signup-tip feature.
- The password coach uses a visible length-only rule; it is guidance, not a security guarantee.
- Preset tips are plain text under 240 characters.
- The missing-data test is triggered with **Test missing local tip data**; **Retry with local data** returns to a successful preset tip.
- No account is created, no data is stored, and no server, credentials, live AI model, or network request is used.

## Tests run

Automated widget tests cover:

1. Empty required fields.
2. Invalid email and password shorter than six characters.
3. Valid form success feedback.
4. Empty, under-eight, and at-least-eight password-coach states.
5. Preset-tip loading and successful result.
6. Missing local tip data and recovery through retry.

Commands:

```text
flutter analyze
flutter test
flutter build apk --release
```

## Graduate reflection — Gowtham Revanur

### 1. Identify one privacy boundary in the local tip feature. What information does it keep out, and why?

The tip feature uses only the fixed category `password_help`; it never reads the name, email address, or password controllers. That separation prevents personal form values from being copied into a feature that does not need them. It also makes the privacy behavior easy to inspect because the category and preset map are constants. Form validators remain the only code that decides whether the signup form passes.

### 2. What should the UI do when local tip data is empty or missing? Explain your error and retry behavior.

When the fixed category returns null or an empty list, the loading state changes to an error card instead of leaving a spinner or showing blank content. The card says that preset data is missing and confirms that no form data was sent or used. A retry button clears the simulated missing-data condition and repeats the same local lookup. This produces a repeatable failure-and-recovery test while the device is offline.

### 3. Describe one trade-off in your local design and a practical improvement.

The deterministic local design is private, reliable offline, and easy to test, but a small fixed list can become repetitive and may not address every user's needs. A practical improvement would be a larger, instructor-reviewed local tip catalog grouped by accessibility and password-literacy needs. The app could rotate tips without collecting form data and include a “Was this useful?” control stored only on-device. That would improve usefulness while preserving the same privacy boundary.

## Trade-off and proposed improvement

Task B deliberately uses a simple, explainable length rule. Its clarity is useful for teaching and testing, but length alone cannot measure real password strength. A future version could add transparent checks for reuse patterns and common passwords from a bundled offline list, while still describing the output as guidance rather than a guarantee.

## Contributions

- Gowtham Revanur: **[Replace with an accurate description of the work you personally performed and can explain.]**
- Partner: **[Add the partner's name and accurate contribution before submission.]**

## Authorship and AI-use note

The assignment page states that generative coding assistants may not write, debug, or answer this activity. This package was prepared with AI assistance and therefore must not be represented as independently authored work. Use it only if your instructor explicitly permits that assistance, and replace the contribution placeholders only with truthful information.
