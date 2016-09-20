<?php

$json  = (file_get_contents('google-services.json'));
$array = json_decode($json, true);

$xml   = new SimpleXMLElement('<resources/>');

arrayToXml($array, $xml);

function arrayToXml($array, &$xml)
{
    foreach($array as $key => $value) {
        if (is_array($value)) {
            if (!is_numeric($key)) {
                $subnode = $xml->addChild("$key");
                arrayToXml($value, $subnode);
            } else {
                arrayToXml($value, $xml);
            }
        } else {
            $xml->addChild("$key","$value");
        }
    }
}

// Formatting
$doc = new DomDocument();
$doc->formatOutput = true;
$doc->loadXML($xml->asXML());
file_put_contents('google_services.xml', $doc->saveXML());