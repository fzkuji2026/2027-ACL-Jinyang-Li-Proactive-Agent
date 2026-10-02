param([string]$PaperMirror)

$ErrorActionPreference = 'Stop'
$paperRoot = $PSScriptRoot
$sourceNames = @(
    '0EPM.tex', '1Introduction.tex', '2ProblemFormulation.tex', '3Framework.tex',
    '4BenchmarkConstruction.tex', '4aExperimentalSetup.tex', '4bResultsAndAnalysis.tex',
    '5RelatedWork.tex', '6Limitations.tex', '7Conclusion.tex', '8EthicalConsiderations.tex',
    '10Appendix.tex', '11Reproducibility.tex', '9Reference.bib',
    'acl.sty', 'acl_natbib.bst', 'lineno.sty',
    'Fig_Intro_Scenario.pdf', 'Fig_Intro_Scenario.tex',
    'Fig1_EPM_Architecture_body.tex', 'Fig1_EPM_Architecture.tex',
    'Fig2_Memory_Hierarchy_body.tex', 'Fig_Model_Sensitivity_Radar.png',
    'Fig_Model_Sensitivity_Radar.svg',
    'README_ACL.md', 'build_paper.ps1', '.gitignore'
)
$pdfNames = @('0EPM.pdf', 'Proactive_Memory_for_Event_Driven_LLM_Agents.pdf')

Push-Location -LiteralPath $paperRoot
try {
    & latexmk -pdf -silent -interaction=nonstopmode -halt-on-error -outdir=build 0EPM.tex
    if ($LASTEXITCODE -ne 0) { throw "LaTeX compilation failed: $LASTEXITCODE" }
    $builtPdf = Join-Path $paperRoot 'build\0EPM.pdf'
    if (-not (Test-Path -LiteralPath $builtPdf -PathType Leaf)) { throw 'Compiled PDF is missing' }
    foreach ($pdfName in $pdfNames) {
        Copy-Item -LiteralPath $builtPdf -Destination (Join-Path $paperRoot $pdfName) -Force
    }
    if ($PaperMirror) {
        $mirrorRoot = [IO.Path]::GetFullPath($PaperMirror)
        if ($mirrorRoot.TrimEnd('\') -eq $paperRoot.TrimEnd('\')) {
            throw 'The mirror must be distinct from the editing directory'
        }
        New-Item -ItemType Directory -Path $mirrorRoot -Force | Out-Null
        foreach ($fileName in ($sourceNames + $pdfNames)) {
            $sourceFile = Join-Path $paperRoot $fileName
            $mirrorFile = Join-Path $mirrorRoot $fileName
            Copy-Item -LiteralPath $sourceFile -Destination $mirrorFile -Force
            if ((Get-FileHash -LiteralPath $sourceFile).Hash -ne (Get-FileHash -LiteralPath $mirrorFile).Hash) {
                throw "Mirror verification failed: $fileName"
            }
        }
        Write-Output "Synchronized $($sourceNames.Count + $pdfNames.Count) files to $mirrorRoot"
    }
    Get-FileHash -LiteralPath ($pdfNames | ForEach-Object { Join-Path $paperRoot $_ }) -Algorithm SHA256 |
        Select-Object Path, Hash
} finally {
    Pop-Location
}
