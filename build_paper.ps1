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
    'Fig_Model_Sensitivity_Sports.png', 'Fig_Model_Sensitivity_Sports.svg',
    'Fig_Model_Sensitivity_Home.png', 'Fig_Model_Sensitivity_Home.svg',
    'Fig_Model_Sensitivity_Code.png', 'Fig_Model_Sensitivity_Code.svg',
    'Fig_Model_Sensitivity_Legend.png', 'Fig_Model_Sensitivity_Legend.svg',
    'README_ACL.md', 'build_paper.ps1', '.gitignore'
)
$pdfNames = @('0EPM.pdf', 'Proactive_Memory_for_Event_Driven_LLM_Agents.pdf')

Push-Location -LiteralPath $paperRoot
try {
    # TeX searches the output directory first; refresh image copies before building.
    $buildRoot = Join-Path $paperRoot 'build'
    New-Item -ItemType Directory -Path $buildRoot -Force | Out-Null
    $imageNames = @($sourceNames | Where-Object { [IO.Path]::GetExtension($_) -in @('.pdf', '.png') })
    foreach ($imageName in $imageNames) {
        $sourceImage = Join-Path $paperRoot $imageName
        $buildImage = Join-Path $buildRoot $imageName
        Copy-Item -LiteralPath $sourceImage -Destination $buildImage -Force
        if ((Get-FileHash -LiteralPath $sourceImage).Hash -ne (Get-FileHash -LiteralPath $buildImage).Hash) {
            throw "Build image verification failed: $imageName"
        }
    }
    & latexmk -pdf -silent -interaction=nonstopmode -halt-on-error -outdir=build 0EPM.tex
    if ($LASTEXITCODE -ne 0) { throw "LaTeX compilation failed: $LASTEXITCODE" }
    $builtPdf = Join-Path $paperRoot 'build\0EPM.pdf'
    if (-not (Test-Path -LiteralPath $builtPdf -PathType Leaf)) { throw 'Compiled PDF is missing' }
    $figureInputs = @(Get-Content -LiteralPath (Join-Path $buildRoot '0EPM.fls') |
        Where-Object { $_ -match '^INPUT .*Fig_Intro_Scenario\.pdf$' } |
        Select-Object -Unique)
    if ($figureInputs.Count -eq 0) { throw 'Figure 1 is missing from the compilation inputs' }
    $figureHash = (Get-FileHash -LiteralPath (Join-Path $paperRoot 'Fig_Intro_Scenario.pdf')).Hash
    foreach ($figureInput in $figureInputs) {
        $inputPath = $figureInput.Substring(6)
        if (-not [IO.Path]::IsPathRooted($inputPath)) { $inputPath = Join-Path $paperRoot $inputPath }
        if ((Get-FileHash -LiteralPath $inputPath).Hash -ne $figureHash) {
            throw "Compiled Figure 1 does not match the current asset: $inputPath"
        }
    }
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
