﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18047
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace FWSyslog.Properties {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    internal class Resources {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal Resources() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("FWSyslog.Properties.Resources", typeof(Resources).Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to 514.
        /// </summary>
        internal static string DefaultSetting_listenport {
            get {
                return ResourceManager.GetString("DefaultSetting_listenport", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to False.
        /// </summary>
        internal static string Service_AutoLog {
            get {
                return ResourceManager.GetString("Service_AutoLog", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to False.
        /// </summary>
        internal static string Service_CanPauseAndContinue {
            get {
                return ResourceManager.GetString("Service_CanPauseAndContinue", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to True.
        /// </summary>
        internal static string Service_CanStop {
            get {
                return ResourceManager.GetString("Service_CanStop", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Monitoring service for Syslog network events from the local gateway&apos;s firewall..
        /// </summary>
        internal static string Service_Description {
            get {
                return ResourceManager.GetString("Service_Description", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Firewall Syslog Recorder.
        /// </summary>
        internal static string Service_Name {
            get {
                return ResourceManager.GetString("Service_Name", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Application.
        /// </summary>
        internal static string WindowsEventLog_Group {
            get {
                return ResourceManager.GetString("WindowsEventLog_Group", resourceCulture);
            }
        }
    }
}
