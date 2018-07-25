package org.collectd.java;

import java.util.List;

// Class holds common util methods used by other classes
class GenericJMXUtils {
  static String join (String separator, List<String> list) /* {{{ */
  {
   StringBuffer sb;

   sb = new StringBuffer ();

   for (int i = 0; i < list.size (); i++)
   {
     if (i > 0) {
       sb.append (separator);
     }
     sb.append (list.get (i));
   }

   return (sb.toString ());
  } /* }}} String join */
 }
