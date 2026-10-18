# Mission Match Helper

## Purpose

Suggest a challenge for the user to complete next.

## Inputs

- Preferred Category
- Challenge Category
- Completion Status

## Scoring Rules

- +2 Category Match
- +1 Unfinished Challenge

## Example

Preferred Category: Art

Art Challenge A = 3

Art Challenge B = 2

Study Challenge C = 1

Recommendation: Challenge A

Reason: Matches the preferred category and remains unfinished.

## Baseline

Sort challenges by Challenge ID only.

## Limitations

This is a rule-based recommendation system.

No machine learning model is used.

Recommendations are based only on:

- Preferred Category
- Challenge Category
- Completion Status