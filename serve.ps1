# Minimal static server for previewing Role-Play-Scorecard.html (no Python/Node needed).
param([string]$File = "Role-Play-Scorecard.html", [int]$Port = 5180)
$path = (Resolve-Path $File).Path
$l = New-Object System.Net.HttpListener
$l.Prefixes.Add("http://localhost:$Port/")
$l.Start()
Write-Host "Serving $path on http://localhost:$Port/"
while ($l.IsListening) {
  $c = $l.GetContext()
  if ($c.Request.Url.AbsolutePath -eq '/') {
    $b = [IO.File]::ReadAllBytes($path)
    $c.Response.ContentType = 'text/html; charset=utf-8'
  } else {
    $b = [Text.Encoding]::UTF8.GetBytes('not found')
    $c.Response.StatusCode = 404
  }
  $c.Response.OutputStream.Write($b, 0, $b.Length)
  $c.Response.Close()
}
