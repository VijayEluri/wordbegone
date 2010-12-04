/*
 * Copyright © 2010 Leanne Northrop
 *
 * This file is part of Publisher Pipeline System.
 *
 * Samye Content Management System is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * Samye Content Management System is distributed in the hope that it will be
 * useful,but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Samye Content Management System.
 * If not, see <http://www.gnu.org/licenses/>.
 *
 * BT plc, hereby disclaims all copyright interest in the program
 * “Publisher Pipeline System” written by Leanne Northrop.
 */
 
package org.northrop.leanne.publisher;

import java.util.*;
import java.io.*;
import org.apache.commons.cli.*;
import groovy.lang.*;
import groovy.util.*;
import java.util.jar.Manifest;
import java.util.jar.Attributes;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.net.URLClassLoader;
import java.net.URL;


/**
 * Entry point for command-line tool. A simple wrapper for a set of groovy 
 * scripts to process input documents to produce output.
 *
 * @author Leanne Northrop
 * @since 29th November 2010, 21:38
 */
public class Main {
    private static Options options;
    
    static {
        File f = new File(System.getProperty("pub.home"), "input/xml");
        Option help = new Option( "help", "Print this message" );      
        Option version = new Option( "version", "Print version information" );            
        Option debug = new Option( "debug", "Create intermediate files." );                                
        Option rerun = new Option( "rerun", "Skip preparation phase and re-run using files currently in '" + f.getAbsolutePath() + "' directory.");                                
                
        options = new Options();
        options.addOption(help);        
        options.addOption(version);
        options.addOption(debug);        
        options.addOption(rerun);        
        
        for (String name : getFormats()) {
            Option opt = new Option(name.toLowerCase(), "Creates as " + name);
            options.addOption(opt);                    
        }           
    }
    
    public static void main(String[] args) {
        CommandLineParser parser = new GnuParser();
        try {
            // parse the command line arguments
            CommandLine line = parser.parse( options, args );
            
            if (args.length == 0 || line.hasOption("help")) {
                HelpFormatter formatter = new HelpFormatter();
                formatter.printHelp( "pub", options );            
            } else if (line.hasOption("version")) {
                URLClassLoader cl = (URLClassLoader)Main.class.getClassLoader();
                String title = "";
                String version = "";
                String date = "";
                try {
                    URL url = cl.findResource("META-INF/MANIFEST.MF");
                    Manifest manifest = new Manifest(url.openStream());
                    Attributes attr = manifest.getMainAttributes();
                    title = attr.getValue("Implementation-Title");
                    version = attr.getValue("Implementation-Version");                    
                    date = DateFormat.getDateTimeInstance(DateFormat.FULL,DateFormat.MEDIUM).format(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(attr.getValue("Built-Date")));                                        
                } catch (Exception e) {
                    e.printStackTrace();
                }
                                
                System.out.println("------------------------------------------------------------");
                System.out.println("Publisher Pipeline " + version);                
                System.out.println("------------------------------------------------------------");
                System.out.println("");
                System.out.println(title + " build time " + date);
                System.out.println("Java: " + System.getProperty("java.version"));                                               
                System.out.println("JVM:  " + System.getProperty("java.vendor"));                                                               
                System.out.println("OS:   " + System.getProperty("os.name") + " " + System.getProperty("os.version") + " " + System.getProperty("os.arch"));                                                                               
            } else {
                Option[] options = line.getOptions();
                Binding binding = new Binding();
                binding.setVariable("home", System.getProperty("pub.home"));
                binding.setVariable("inputDir", System.getProperty("pub.home") + "/input");                
                binding.setVariable("outputDir", System.getProperty("pub.home") + "/output");                                
                binding.setVariable("appName", System.getProperty("program.name"));                
                binding.setVariable("isdebug", false);                
                                
                for (int i = 0; i < options.length; i++) {
                    Option opt = options[i];
                    binding.setVariable("is" + opt.getOpt(), true);
                }

                String[] roots = new String[] { System.getProperty("pub.home")+"/resources/scripts",System.getProperty("pub.home")+"/resources/scripts/formats"};
                ClassLoader parent = Main.class.getClassLoader();
                GroovyScriptEngine gse = new GroovyScriptEngine(roots,parent);
                
                if (!line.hasOption("rerun")) {
                    gse.run("prep.groovy", binding);
                }

                for (String name : getFormats()) {
                    if (line.hasOption(name.toLowerCase())) {
                        String file = ("" + name.charAt(0)).toLowerCase() + name.substring(1) + ".groovy";
                        gse.run(file, binding);
                    }             
                }                           
            }            
        }
        catch(ParseException exp) {
            System.err.println( "Command line parsing failed.  Reason: " + exp.getMessage());
        }
        catch (ResourceException resourceError){
            System.err.println("Groovy script failed.  Reason: " + resourceError.getMessage());
        }
        catch (IOException ioError){
            System.err.println("Groovy script failed.  Reason: " + ioError.getMessage());
        } catch (ScriptException error) {
            System.err.println("Groovy script failed.  Reason: " + error.getMessage());            
            error.printStackTrace();
        }        
    }
        
    protected static List<String> getFormats() {
        Binding binding = new Binding();
        binding.setVariable("home", System.getProperty("pub.home"));
        binding.setVariable("formatsScriptDir", System.getProperty("pub.home")+"/resources/scripts/formats");        
        
        GroovyShell shell = new GroovyShell(binding);        
        List<String> filenames = (List<String>)shell.evaluate("new File(formatsScriptDir).listFiles([accept:{d,f-> f ==~ /.*?\\.groovy/ }] as FilenameFilter).toList()*.name.collect{it.capitalize()[0..-8]}");
        return filenames;        
    }

}