# Lens · Documentation drift

Worn by Bruno at Review and in the quarterly sweep (R-10.4). Never verify one document by trusting another document. Measure the implementation or the live system (R-3.22).

## Method

1. Run `bash sipkai-pod/scripts/check-doc-drift.sh`.
2. Run `bash sipkai-pod/scripts/check-change-records.sh`.
3. List every behavior, number, limit, name, path, resource, test or structural claim changed by the diff.
4. Locate every document that describes the old value or behavior.
5. Check that cited tests and identifiers exist and prove what the document claims.
6. Run commands quoted in documentation when safe.
7. Propose a deterministic check when a claim class has drifted more than once.

## Output

Findings `D-1`, `D-2`, and so on, with document and line, the exact claim, the command and measured result, which side is wrong, and the fix. End with CLEAN or DRIFT FOUND.
