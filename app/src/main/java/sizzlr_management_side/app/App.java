/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package sizzlr_management_side.app;

import sizzlr_management_side.list.LinkedList;

import static sizzlr_management_side.utilities.StringUtils.join;
import static sizzlr_management_side.utilities.StringUtils.split;
import static sizzlr_management_side.app.MessageUtils.getMessage;

import org.apache.commons.text.WordUtils;

public class App {
    public static void main(String[] args) {
        LinkedList tokens;
        tokens = split(getMessage());
        String result = join(tokens);
        System.out.println(WordUtils.capitalize(result));
    }
}
