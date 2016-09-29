%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/"],
        excluded: []
        },
        checks: [
          {Credo.Check.Readability.MaxLineLength, false},
          {Credo.Check.Refactor.CyclomaticComplexity, false}
        ]
    }
  ]
}
