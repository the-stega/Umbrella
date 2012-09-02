<?php
# Call magpierss
require_once('magpierss/rss_fetch.inc');
#Change this variable to control the number of entries displayed on each page.
$how_many=HOW_MANY;
#
#Change this to the path for your feed.xml
$url='URL_REPLACE/feed.xml';
#
#Change this entry if you wish to use your own stylesheet
$style_sheet='STYLESHEET_REPLACE>';


###Begin function to display page

function print_nav($skip, $show, $rss_size)
{
    $prev=($skip - $show);

    if ($prev < 0)
        $prev=0;

    if($skip != 0)
        echo "<a href=".$_SERVER['PHP_SELF']."?show=$show&skip=$prev>";

    echo "next";

    if($skip != 0)
        echo "</a>";

    echo "\n";

    echo " -- ";

    $next=($skip + $show);

    if(($rss_size - $next) > 0)
        echo "<a href=".$_SERVER["PHP_SELF"]."?show=$show&skip=$next>";

    echo "previous";

    if(($rss_size - $next) > 0)
        echo "</a>";

    echo "\n";
}


echo "<html>\n";
echo "<head>\n";
echo "<title>\n";
echo "something from a phone.\n";
echo "</title>\n";
echo "<link rel=stylesheet type=text/css href=\"";
echo $style_sheet;
echo "\">\n";
echo "</head>\n";
echo "<body>\n";
echo "<div id=\"header\">\n";
echo "<h3>\n";
echo "Something of interest....</h3>\n";

if(isset($_GET['skip'])){
    $skip=$_GET['skip'];
} else {
    $skip=0;
}


$PHP_SELF=$_SERVER['PHP_SELF'];
if(isset($_GET['show'])){
    $show=$_GET['show'];
} else {

    $show=$how_many;
}

$url=$my_url;
$rss = fetch_rss($url);
$rss_size=sizeof($rss->items);

print_nav($skip, $show, $rss_size);
echo "<hr align=left width=50%>";

for( $i = $skip; $i < $rss_size && ($i - $skip) < $show; $i++ ){
    $item=$rss->items[$i];
    $title=substr($item['title'], (strpos($item['title'], " ") + 1));
    $date=substr($item['title'], 0, strpos($item['title'], " "));
    $desc=$item['description'];
    echo "<table border=0 class=nav1>\n";
    echo "<tr>\n";
    echo "<td><h3>$title</h3></td>\n";
    echo "</tr>\n";
    echo "<tr>\n";
    echo "<td><h3>$date</h3></td>\n";
    echo "</tr>\n";
    echo "<tr>\n";
    echo "<td align=center>$desc</td>\n";
    echo "</tr>\n";
    echo "</table>";
    echo "<hr align=left width=25%>";
}
print_nav($skip, $show, $rss_size);
echo "</div>";

echo "</body>\n";
echo "</html>\n";
?>
