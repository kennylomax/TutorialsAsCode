package testing;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.List;
import java.nio.file.Paths;
import org.junit.jupiter.api.Test;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.lang3.StringUtils;
import static org.junit.jupiter.api.Assertions.*;

class JourneyTest {
    final static Logger LOGGER = Logger.getLogger(JourneyTest.class.getName());

    @Test
    public void runThruTutorial() throws Exception{
        String journeyName = System.getProperty("journey");
        String fromCmd = System.getProperty("fromCmd");
        String toCmd = System.getProperty("toCmd");
        String path = String.valueOf(System.getProperty("Path"));
        System.out.println("Path is "+path);
        String os = System.getProperty("os.name");
        Boolean runningOnMac = os.contains("Mac");
        System.out.println("Testing journey: "+journeyName+"\nRunningOnMac is "+ runningOnMac+"\nPath is "+path);
        System.out.println("README : "+  path+"/journeys/"+journeyName+"/README.md");
        System.out.println("commands.sh : "+  path+"/commands.sh");
        confirmEachClickPathAppearsInAScenario(path+"/journeys/"+journeyName+"/README.md", path+"/journeys/"+journeyName+"/journey.feature");
        readMeToScript( path+"/journeys/"+journeyName+"/README.md", path+"/journeyvalidator/commands.sh", runningOnMac, fromCmd, toCmd);
        runCommand("chmod 700 "+path+"/journeyvalidator/commands.sh");
        runCommand(path+"/journeyvalidator/commands.sh");
    }

    public void confirmEachClickPathAppearsInAScenario(String readMeFile, String featureFile) throws IOException{
        String content = Files.readString(Paths.get(readMeFile), StandardCharsets.US_ASCII);
        String feature = Files.readString(Paths.get(featureFile), StandardCharsets.US_ASCII);
        // ```clickpath[0-9a-zA-Z_:. &()${}/+\\,\-=<>\n]*```
        String regexp = "```clickpath[0-9a-zA-Z_:. &()${}/+\\\\,\\-=<>\\n]*```";
        Pattern p = Pattern.compile(regexp);
        Matcher m = p.matcher(content);
        while (m.find()){
            String s = m.group(0);
            String clickpathName = s.split(":", 2)[1].split("\n", 2)[0];
            String clickpath = s.split("\n", 2)[1].split("```",2)[0];
            String expectedFeatureOccurence = "@"+clickpathName+"\nScenario:\n\"\"\"\n"+clickpath+"\"\"\"";
            assertTrue(  feature.contains(expectedFeatureOccurence), "Expecting to find "+expectedFeatureOccurence );
        }
    }

    public void readMeToScript(String fileFrom, String fileTo, boolean runningOnMac, String sFromCmd, String sToCmd)throws Exception{
        int fromCmd=0, toCmd=999;
        if (StringUtils.isNumeric(sFromCmd))
            fromCmd = Integer.parseInt(sFromCmd);
        if (StringUtils.isNumeric(sToCmd))
            toCmd = Integer.parseInt(sToCmd);

        StringBuffer script = new StringBuffer();
        List<String> lines = Files.readAllLines(Paths.get(fileFrom));
    
        boolean commands = false;
        boolean clickpath = false;
        boolean file = false;
        String clickPathName="";
        String lastBoldText =""; 
        boolean addedClickpath=false;
        if (!runningOnMac)
            script.append("#!/bin/bash\n "); 
        script.append("export TESTING_HOME=$PWD ; ");
        int i=0;
        for (int j=0; j<lines.size() ; j++){
            String l=lines.get(j);
            
            if ( l.contains("**") && l.indexOf("**")  != l.lastIndexOf("**")){
                lastBoldText = l.substring(l.indexOf("**")+2, l.lastIndexOf("**"));
            }
            if  (  l.startsWith("```commands" )){
                if (    runningOnMac && l.startsWith("```commandsDebianOnly" ) ||
                        !runningOnMac && l.startsWith("```commandsOsxOnly" ))
                    ;
                else
                    commands = true;
            }
            else if (l.startsWith("```clickpath"))
                clickpath = true;
            else if (l.startsWith("```file")){
                file=true;
            }
            else if (l.startsWith("```")){
                commands=false;
                clickpath=false;
                file=false;
            }

            if ( commands &&  !l.startsWith("```commands")){
                if (l.length()>0){              
                    if (i>=fromCmd&& i<=toCmd) {
                        script.append("echo Command["+i +"]: ;");               
                        script.append("echo \"\u001b[31m $PWD : \u001b[32m"+l+"\u001b[0m\"; ");

                        if (l.trim().endsWith("&"))
                            script.append(l+" ");
                        else
                            script.append(l+"; ");
                    }
                    else{
                        script.append("echo Command["+i +"]: ;");               
                        script.append("echo \"\u001b[31m $PWD : \u001b[31m"+l+"\u001b[0m\"; ");
                    }
                    i++;
                }
            }
            else if  ( clickpath &&  l.startsWith("```clickpath:")){
                addedClickpath=false;
                clickPathName=l.substring("```clickpath:".length());
            }
            else if  ( clickpath &&  !l.startsWith("```clickpath") && !addedClickpath){
                addedClickpath=true;
                script.append("echo Command["+i +"]: ;");
                script.append("echo \"\u001b[34m Clickpath "+l+"\"; ");           
                script.append("pushd ${TESTING_HOME}; ");
                if (runningOnMac){
                    if (i>=fromCmd && i<=toCmd){
                        String c =  "mvn clean test -Dkarate.options='--tags @"+clickPathName+"' -Dtest=\\!JourneyTest#runThruTutorial;  ";
                        script.append("echo \"\u001b[32m"+c+"\u001b[0m\"; ");
                        if (i>=fromCmd && i<=toCmd)
                            script.append(c);
                    }
                    else{
                        String c =  "mvn clean test -Dkarate.options='--tags @"+clickPathName+"' -Dtest=\\!JourneyTest#runThruTutorial;  ";
                        script.append("echo \"\u001b[31m"+c+"\u001b[0m\"; ");
                    }
                }else {
                     if (i>=fromCmd && i<=toCmd){
                        String c = "mvn test  -Dtest=\\!JourneyTest#runThruTutorial -DargLine='-Dkarate.env=docker -Dkarate.options=\"--tags @"+clickPathName+ "\"' -Dtest=WebRunner; ";             
                        script.append("echo \"\u001b[32m"+c+"\u001b[0m\"; ");
                        script.append(c);
                        script.append("mkdir -p /src/journey/$NOW;  cp /tmp/karate.mp4 /src/journey/$NOW/karate_"+clickPathName+".mp4; ");
                    }
                    else{
                        String c = "mvn test  -Dtest=\\!JourneyTest#runThruTutorial -DargLine='-Dkarate.env=docker -Dkarate.options=\"--tags @"+clickPathName+ "\"' -Dtest=WebRunner; ";             
                        script.append("echo \"\u001b[31m"+c+"\u001b[0m\"; ");
                    }
                }  
                script.append("popd; ");
                i++;
            }
            else if (file){
                String contents = "";
                l=lines.get(++j);
                while  (!l.contains("```")){
                    contents += l+"\n";
                    l=lines.get(++j);
                } 
                j--;
//                contents=contents.replace("|","\|");
//                contents=contents.replace("'","\\\"");
                String command = "echo '"+contents+"' > "+lastBoldText +";";
                script.append("echo Command["+i++ +"]: ;");               
                    if (i>fromCmd&& i<toCmd){
                        script.append("echo \"\u001b[32m $PWD :  \u001b[32m"+command+"\u001b[0m\"; ");
                        script.append(command);
                    }
                    else {
                        script.append("echo \"\u001b[31m $PWD :  \u001b[31m"+command+"\u001b[0m\"; ");
                    }
            }
        }
        BufferedWriter writer = new BufferedWriter(new FileWriter(fileTo));
        writer.write(script.toString());
        writer.close();
        //System.out.println(script.toString());
    }

    public void runCommand(String s) throws IOException, InterruptedException {
        System.out.println("\u001b[34m"+s+"\u001b[0m" );
        ProcessBuilder builder = new ProcessBuilder();
        builder.command(s.split(" "));   
        builder.redirectErrorStream(true);
        Process process = builder.start();
        BufferedReader reader =  new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line;
        while ((line = reader.readLine()) != null) {
            System.out.println(line);
            assertFalse( line.toLowerCase().contains("err!") || 
                line.toLowerCase().contains("[error]") || 
                line.toLowerCase().contains("not found: npm") ||
                line.toLowerCase().contains("fatal: authentication failed") ||
                line.toLowerCase().contains("no such file")
            );
         }
        int exitCode = process.waitFor();
        assert exitCode == 0;
    }
}

