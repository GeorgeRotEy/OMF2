tableextension 50002 "G/L Budget Name Ext" extends "G/L Budget Name"
{
    fields
    {
        field(50000; Active; Boolean)
        {
            Caption = 'Active',
            Comment = 'ESP="Activo"';

            trigger OnValidate()
            begin
                //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Inicio
                IF NOT Active THEN
                    EXIT;

                IF Blocked THEN
                    ERROR(Error002);

                rGLBudgetName.RESET();
                rGLBudgetName.SETCURRENTKEY(Active);
                rGLBudgetName.SETRANGE(Active, TRUE);
                IF rGLBudgetName.FINDFIRST() THEN
                    ERROR(Error001, rGLBudgetName.Name);

                //(1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos. Inicio
                //IF "Last Year Budget" THEN
                //ERROR(Error007);
                //(1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos. Fin

                //Mod. S2G (RBM-R) GF-007: Control Presupuestario. Fin
            end;
        }
        field(50001; Template; Boolean)
        {
            Caption = 'Template',
            Comment = 'ESP="Plantilla"';

            trigger OnValidate()
            begin
                //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Inicio
                IF NOT Template THEN
                    EXIT;

                IF Blocked THEN
                    ERROR(Error002);

                rGLBudgetName.RESET();
                rGLBudgetName.SETCURRENTKEY(Template);
                rGLBudgetName.SETRANGE(Template, TRUE);
                IF rGLBudgetName.FINDFIRST() THEN
                    ERROR(Error005, rGLBudgetName.Name);
                //(CR003) S2G (RBM-R) 07-08-18: Modificaciones Registro simple. Fin
            end;
        }
        field(50002; "Last Year Budget"; Boolean)
        {
            Caption = 'Previous Year Budget',
            Comment = 'ESP="Presupuesto del año anterior"';

            trigger OnValidate()
            begin
                //(1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos. Inicio
                //IF NOT "Last Year Budget" THEN
                //EXIT;

                //rGLBudgetName.RESET();
                //rGLBudgetName.SETRANGE("Last Year Budget", TRUE);
                //IF rGLBudgetName.FINDFIRST() THEN
                //ERROR(Error006, rGLBudgetName.Name);

                //IF Active THEN
                //ERROR(Error007);
                //(1.5) S2G (RBM-R) 09-03-20: Modificaciones presupuestos. Fin
            end;
        }
        field(50003; "Power BI"; Boolean)
        {
            Caption = 'Power BI',
            Comment = 'ESP="Disponible para Power BI"';
        }
    }

    keys
    {
        key(Key2; Active)
        {
        }
        key(Key3; Template)
        {
        }
    }

    var
        rGLBudgetName: Record "G/L Budget Name";
        Error001: Label 'Ya está activo el presupuesto %1.';
        Error002: Label 'No se puede activar un presupuesto bloqueado';
        Error005: Label 'Ya existe como plantilla el presupuesto %1.';
}