//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ProjectApplication.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class course_timeslot
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public course_timeslot()
        {
            this.COURSE_INST_PREFERENCES = new HashSet<COURSE_INST_PREFERENCES>();
            this.COURSE_INST_PREFERENCES1 = new HashSet<COURSE_INST_PREFERENCES>();
        }
    
        public int courseTimeslot_id { get; set; }
        public string courseTiming { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<COURSE_INST_PREFERENCES> COURSE_INST_PREFERENCES { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<COURSE_INST_PREFERENCES> COURSE_INST_PREFERENCES1 { get; set; }
    }
}
