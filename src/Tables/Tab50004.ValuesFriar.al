table 50004 "Values Friar"
{
    Caption = 'Friar Jobs', Comment = 'ESP="Oficios del hermano"';

    fields
    {
        field(1; "Job type"; Option)
        {
            Caption = 'Job Type', Comment = 'ESP="Tipo de oficio"';
            OptionCaption = ' ,Curia title,Fraternity title,Activity title,Economy title,Secretary for missions and evangelization,Secretary for education, Other ';
            OptionMembers = " ","Cargo provincial","Cargo de las casas","Cargo de las actividades","Cargo asuntos enconómicos","Secretaria para las misiones y evangelización","Secretaria para la formación y los estudios","Otras comisiones";
        }
        field(2; Job; Text[50])
        {
            Caption = 'Job', Comment = 'ESP="Oficio"';
        }
        field(3; Category; Text[30])
        {
            Caption = 'Category', Comment = 'ESP="Categoría"';
        }
        field(4; Id_job; Code[10])
        {
            Caption = 'Job ID', Comment = 'ESP="Id_Job"';
        }
    }

    keys
    {
        key(Key1; Id_job, "Job type", Category, Job)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
