$m2 = "C:\Users\admin\.m2\repository"
$web_lib = "c:\Users\admin\eclipse-workspace\941_newdb\src\main\webapp\WEB-INF\lib"
$target_lib = "c:\Users\admin\eclipse-workspace\941_newdb\target\efile941\WEB-INF\lib"
$target_lib_legacy = "c:\Users\admin\eclipse-workspace\941_newdb\target\newdb\WEB-INF\lib"

New-Item -ItemType Directory -Force -Path $web_lib
New-Item -ItemType Directory -Force -Path $target_lib
New-Item -ItemType Directory -Force -Path $target_lib_legacy

# Find all Tomcat wtpwebapps WEB-INF/lib directories in Eclipse metadata
$wtp_libs = Get-ChildItem -Path "C:\Users\admin\eclipse-workspace\.metadata\.plugins\org.eclipse.wst.server.core" -Filter "WEB-INF" -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer } | Select-Object -ExpandProperty FullName

$jars = @(
    "spring-web-5.3.31.jar",
    "spring-webmvc-5.3.31.jar",
    "spring-context-5.3.31.jar",
    "spring-beans-5.3.31.jar",
    "spring-core-5.3.31.jar",
    "spring-aop-5.3.31.jar",
    "spring-expression-5.3.31.jar",
    "spring-jcl-5.3.31.jar",
    "spring-jdbc-5.3.31.jar",
    "spring-tx-5.3.31.jar",
    "postgresql-42.7.3.jar",
    "javax.servlet-api-4.0.1.jar",
    "jstl-1.2.jar",
    "checker-qual-3.42.0.jar"
)

foreach ($j in $jars) {
    $found = Get-ChildItem -Path $m2 -Filter $j -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($found) {
        Copy-Item $found.FullName -Destination $web_lib -Force
        Copy-Item $found.FullName -Destination $target_lib -Force
        Copy-Item $found.FullName -Destination $target_lib_legacy -Force
        foreach ($wtp in $wtp_libs) {
            $wtpLib = Join-Path $wtp "lib"
            if (Test-Path $wtpLib) {
                Copy-Item $found.FullName -Destination $wtpLib -Force
            }
        }
    } else {
        Write-Warning "Could not find $j in $m2"
    }
}
Write-Host "All deployment JARs successfully restored to WEB-INF/lib, target, and Tomcat server directories!"
