

<!-- omit in toc -->

# Contributing to FieldOps.jl

Thanks for taking the time to contribute.

FieldOps.jl is a small, solo-maintained package, pre-registration and pre-1.0.0. All types of contributions are welcome, but given the size of the project right now, the most useful contributions are small and self-contained, and avoid the core operator or coordinate-system code while that's still being finished. See below for the different ways to help.

<!-- omit in toc -->

## Table of Contents

- [I Have a Question](#i-have-a-question)
- [I Want To Contribute](#i-want-to-contribute)
- [Project Status](#project-status)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)
- [Your First Code Contribution](#your-first-code-contribution)
- [Improving The Documentation](#improving-the-documentation)
- [Styleguides](#styleguides)
- [Commit Messages](#commit-messages)

## I Have a Question

> If you want to ask a question, I assume that you've read the available [Documentation](https://michaeljhanley.github.io/FieldOps.jl).

Before you ask a question, it is best to search for existing [Issues](https://github.com/michaeljhanley/FieldOps.jl/issues) that might help you. In case you have found a suitable issue and still need clarification, you can write your question in this issue. It is also advisable to search the internet for answers first.

If you then still feel the need to ask a question and need clarification, we recommend the following:

- Open an [Issue](https://github.com/michaeljhanley/FieldOps.jl/issues/new).
- Provide as much context as you can about what you're running into.
- Provide project and platform versions (Julia version, OS), depending on what seems relevant.

I'll respond as soon as I can. This is a one-person project, so a reply might take a few days rather than a few hours.

## I Want To Contribute

> ### Legal Notice
> 
> When contributing to this project, you must agree that you have authored 100% of the content, that you have the necessary rights to the content, and that the content you contribute may be provided under the project licence.

### Project Status

FieldOps.jl is pre-registration and pre-1.0.0. A few things follow from that:

- The public API can still change. The coordinate-system type architecture is mid-refactor: `Cartesian`, `Cylindrical`, and `Spherical` are moving from constructor functions to named struct types. If you're building against the current internals, expect some churn until 0.1.0 ships.
- Scope is intentionally narrow for now. The package is numerical-first: it computes gradient, divergence, curl, and Laplacian via ForwardDiff.jl, in Cartesian, cylindrical, spherical, and user-defined orthogonal coordinate systems. A symbolic backend via Symbolics.jl might arrive as an optional extension much later, but it isn't a core dependency, so PRs adding SymPy or a required symbolic path are out of scope.
- There's no project team. One maintainer triages issues and PRs, so labeling and response times are informal.

### Reporting Bugs

<!-- omit in toc -->

#### Before Submitting a Bug Report

A good bug report shouldn't leave others needing to chase you up for more information. Please complete the following steps in advance to help fix any potential bug as fast as possible.

- Make sure that you are using the latest version.
- Determine if your bug is really a bug and not an error on your side, e.g. using an incompatible Julia version or a coordinate system's output basis convention (results are returned in the local curvilinear basis, not Cartesian components; see the docs). If you are looking for support instead, check [this section](#i-have-a-question).
- Check if there's already a bug report for it in the [bug tracker](https://github.com/michaeljhanley/FieldOps.jl/issues?q=label%3Abug).
- Also check if others have discussed the issue outside GitHub (e.g. Julia Discourse, Stack Overflow).
- Collect information about the bug:
  - Stack trace (Traceback)
  - OS, Platform and Version (Windows, Linux, macOS, x86, ARM)
  - Julia version and relevant package versions (`] status`)
  - Your input and the output you got
  - Whether you can reliably reproduce the issue, and with which coordinate system

<!-- omit in toc -->

#### How Do I Submit a Good Bug Report?

> Please never report security-related issues or vulnerabilities in the public issue tracker. Use GitHub's private security advisory feature for this repository instead.

I use GitHub issues to track bugs and errors. If you run into an issue with the project:

- Open an [Issue](https://github.com/michaeljhanley/FieldOps.jl/issues/new). (Since it isn't yet confirmed as a bug, please don't label it yourself.)
- Explain the behavior you expected and the actual behavior.
- Provide the *reproduction steps* someone else can follow, including a minimal code example, ideally the specific `gradient`/`divergence`/`curl`/`laplacian` call, coordinate system, and point.
- Include the information collected above.

Once it's filed, I'll try to reproduce it and follow up if I need more information.

### Suggesting Enhancements

This section covers suggestions for FieldOps.jl, including new features and improvements to existing functionality.

<!-- omit in toc -->

#### Before Submitting an Enhancement

- Make sure you're using the latest version.
- Check the [documentation](https://michaeljhanley.github.io/FieldOps.jl) to see if it's already covered.
- Search [existing issues](https://github.com/michaeljhanley/FieldOps.jl/issues) to see if it's already been suggested; comment there instead of opening a duplicate.
- Consider whether it fits the project's scope (see [Project Status](#project-status) above): numerical, ForwardDiff-based, orthogonal coordinate systems. Features useful to a broad set of users are a better fit than ones serving a narrow use case.

<!-- omit in toc -->

#### How Do I Submit a Good Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://github.com/michaeljhanley/FieldOps.jl/issues).

- Use a clear, descriptive title.
- Describe the suggested enhancement step by step.
- Describe the current behavior and what you'd expect instead, and why.
- Explain why this would help most FieldOps.jl users. Pointing to how another package or library handles it can help make the case.

### Your First Code Contribution

The core operator and coordinate-system code (`src/coordinate_systems.jl`, `src/operators.jl`) is still being finished, so the best starting points right now are tasks that are well-specified and don't touch that code:

- Analytical closed-form tests for cylindrical and spherical coordinates, e.g. Δ(r²) = 4 in cylindrical and ∇·(r r̂) = 3 in spherical. These are pure test-writing against an existing, documented API.
- The parabolic cylindrical validation test: a worked example (h₁ = h₂ = √(μ²+ν²), h₃ = 1) that exercises the `CurvilinearCoords` user-defined API against a coordinate system nobody's hand-rolled a preset for. Good for confirming the extension mechanism generalizes.
- Check open issues tagged `good first issue` (once that label exists) for anything more current.

If you'd like to work on something closer to the core, such as the coordinate-system type refactor or the operator implementations, please open an issue first to check it's not already in progress. This is a one-person project, so duplicated effort is a real risk otherwise.

To get set up: clone the repo, run `] instantiate` from the package directory, then `] test` to confirm the existing suite passes before making changes.

### Improving The Documentation

Documentation contributions are welcome, particularly:

- Docstrings for exported functions (`gradient`, `divergence`, `curl`, `laplacian`, `scale_factors`, coordinate system constructors). A good docstring has a one-sentence description, the argument types, and a concrete worked example with expected output.
- Some documentation pages, the math background page and the extension guide, don't exist yet, so contributing to these means drafting new content, not just editing. Open an issue first to coordinate scope.
- Fixes to the README or existing docs pages (typos, broken links, unclear examples) are always welcome without needing to check in first.

## Styleguides

### Commit Messages

There's no strict convention enforced yet. A clear, present-tense summary line (e.g. "Fix curl return type to SVector") is appreciated. If you're used to [Conventional Commits](https://www.conventionalcommits.org/), that style is also fine.

<!-- omit in toc -->

## Attribution

This guide is based on the [contributing.md](https://contributing.md/generator)!
