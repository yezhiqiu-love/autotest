package com.custom;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

/**
 * @author jizhang
 *
 */
public class XmlFitNesseResultsCleaner {

/**
 * @param args
 * @throws Exception 
 */
public static void main(String[] args) throws Exception {
    ArgumentsParser arguments = new ArgumentsParser(args);
    System.out.println("Cleaning up " + arguments.sourceFile);

    TempFileReader reader = new TempFileReader(arguments.getSourceFile());
    String xmlContents = reader.getXmlContentsOfFile();
    XmlResultFileWriter.saveAsFile(xmlContents, arguments.getDestFile());

    System.out.println("Cleaned up XML file saved as " + arguments.getDestFile());
}

}

class ArgumentsParser {
String sourceFile = "";
String destFile = "";

public ArgumentsParser(String[] args) throws Exception {
    if (args.length < 2) {
        throw new Exception("Insufficent arguments");
    }

    sourceFile = args[0];
    destFile = args[1];
}

public String getSourceFile() {
    return sourceFile;
}

public String getDestFile() {
    return destFile;
}
}

class TempFileReader {
String filename = "";

boolean inXml = false;

String xmlContents = "";

public TempFileReader(String filename) {
    this.filename = filename;
    inXml = false;
}

public String getXmlContentsOfFile() throws IOException {
    BufferedReader br = null;
    try {
        br = new BufferedReader(new FileReader(filename));

        String currentLine = "";

        while ((currentLine = br.readLine()) != null) {
            checkForXmlStart(currentLine);
            addToXmlContents(currentLine);
            if (isLastLineOfXml(currentLine)) break;
        }

    }
    catch (FileNotFoundException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
    }
    finally {
        if (br != null) {
            br.close();
        }
    }

    return xmlContents;
}

private void addToXmlContents(String currentLine) {
    if (inXml) {
        xmlContents = xmlContents + currentLine + "\n";
    }
}

private void checkForXmlStart(String currentLine) {
    if (!inXml && currentLine.equals("<?xml version=\"1.0\"?>")) {
        inXml = true;
    }
}

private boolean isLastLineOfXml(String currentLine) {
    if (inXml && currentLine.equals("</suiteResults>")) {
        return true;
    }
    else {
        return false;
    }
}
}

class XmlResultFileWriter {

public static void saveAsFile(String contents, String filename)
        throws IOException {
    BufferedWriter writer = null;
    try {
        writer = new BufferedWriter(new FileWriter(filename));
        writer.write(contents);

    }
    catch (IOException e) {
        e.printStackTrace();
    }
    finally {
        if (writer != null) {
            writer.close();
        }
    }
}

}