table 50351 "Regimen Actual"
{
    fields
    {
        field(1; "Nº Serie Friar"; Code[10])
        {
            Caption = 'Friar Series No.', Comment = 'ESP="Nº Serie Hermano"';
            TableRelation = Friar."No. Serie Friar";
        }
        field(2; "Tipo Regimen"; Option)
        {
            Caption = 'Scheme Type', Comment = 'ESP="Tipo régimen"';
            OptionCaption = 'General Nómina,Autonomo,General Diócesis,Pensionista,Salario Adecuado,Seguro Médico';
            OptionMembers = "General Nómina",Autonomo,"General Diócesis",Pensionista,"Salario Adecuado","Seguro Médico";
        }
        field(3; "Régimen Actual"; Boolean)
        {
            Caption = 'Current Scheme', Comment = 'ESP="Régimen actual"';

            trigger OnValidate()
            var
                RegimenActual: Record "Regimen Actual";
            begin
                //TEMS-267
                IF "Régimen Actual" THEN BEGIN
                    RegimenActual.RESET;
                    RegimenActual.SETFILTER(ID, '<>%1', Rec.ID);
                    RegimenActual.SETRANGE("Nº Serie Friar", "Nº Serie Friar");
                    RegimenActual.SETRANGE("Tipo Regimen", "Tipo Regimen");
                    RegimenActual.SETRANGE("Régimen Actual", TRUE);
                    IF RegimenActual.FINDFIRST() THEN
                        ERROR(STRSUBSTNO('Ya existe un Regimen activo para el Hermano %1 y Tipo de Regimen %2', "Nº Serie Friar", "Tipo Regimen"));
                END;
            end;
        }
        field(4; "Fecha Inicio"; Date)
        {
            Caption = 'Start Date', Comment = 'ESP="Fecha inicio"';
        }
        field(5; "Fecha Fin"; Date)
        {
            Caption = 'End Date', Comment = 'ESP="Fecha fin"';
        }
        field(6; ID; Integer)
        {
            Caption = 'ID', Comment = 'ESP="ID"';
            AutoIncrement = true;
        }
        field(7; "Importe/Base"; Decimal)
        {
            Caption = 'Amount/Base', Comment = 'ESP="Importe/Base"';
        }
        field(8; Base; Decimal)
        {
            Caption = 'Base', Comment = 'ESP="Base"';
        }
        field(9; "Nombre Hermano"; Text[50])
        {
            CalcFormula = Lookup(Friar.Name WHERE("No. Serie Friar" = FIELD("Nº Serie Friar")));
            Caption = 'Friar Name', Comment = 'ESP="Nombre Hermano"';
            FieldClass = FlowField;
        }
        field(10; "Apellido Hermano"; Text[50])
        {
            CalcFormula = Lookup(Friar.Apellidos WHERE("No. Serie Friar" = FIELD("Nº Serie Friar")));
            Caption = 'Friar Surname', Comment = 'ESP="Apellido Hermano"';
            FieldClass = FlowField;
        }
        field(11; "Segundo Apellido"; Text[50])
        {
            Caption = 'Second Surname', Comment = 'ESP="Segundo apellido"';
        }
        field(12; "Seguro Médico"; Option)
        {
            Caption = 'Medical Insurance', Comment = 'ESP="Seguro médico"';
            OptionCaption = ' ,No,Sanitas,Sanitas VOCARE,Asisa General,Asisa Misionero';
            OptionMembers = " ",No,Sanitas,"Sanitas VOCARE","Asisa General","Asisa Misionero";
        }
        field(13; "Importe Médico"; Decimal)
        {
            Caption = 'Medical Amount', Comment = 'ESP="Importe médico"';
        }
        field(14; "Tipo Pensionista"; Option)
        {
            Caption = 'Pensioner Type', Comment = 'ESP="Tipo pensionista"';
            OptionCaption = ' ,Contributiva,No Contributiva';
            OptionMembers = " ",Contributiva,"No Contributiva";
        }
        field(15; "Importe Pensionista"; Decimal)
        {
            Caption = 'Pensioner Amount', Comment = 'ESP="Importe pensionista"';
            FieldClass = Normal;
        }
        field(17; "Importe Seguro Médico"; Decimal)
        {
            Caption = 'Medical Insurance Amount', Comment = 'ESP="Importe seguro médico"';
            FieldClass = Normal;
        }
        field(18; "Salario Adecuado"; Decimal)
        {
            Caption = 'Adequate Salary', Comment = 'ESP="Salario adecuado"';
        }
    }

    keys
    {
        key(Key1; "Nº Serie Friar", "Tipo Regimen", ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    local procedure CrearAutonomo()
    begin
    end;

    local procedure EliminarAutonomo()
    begin
    end;
}
