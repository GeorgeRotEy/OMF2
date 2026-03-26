// report 99997 "Prueba Fichero TXT"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './PruebaFicheroTXT.rdlc';
//     ProcessingOnly = false;
//     ApplicationArea = All;

//     dataset
//     {
//         dataitem(Donation; Donation)
//         {
//             MaxIteration = 1;
//             column(NumeroDon; NumeroDon)
//             {
//             }
//             column(FechaRegistro; FechaRegistro)
//             {
//             }
//             column(Importe; Importe)
//             {
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 //
//                 // CLEAR(OutputFile);
//                 // OutputFile.TEXTMODE:=TRUE;
//                 // OutputFile.WRITEMODE:=TRue;
//                 // OutputFile.CREATE('C:\fichero.txt');
//                 //
//                 // //OutputFile.OPEN('C:\fichero.txt');
//                 //
//                 //
//                 // OutputFile.WRITE('HOLA');
//                 //
//                 // OutputFile.CLOSE();

//                 // donation.RESET();
//                 // IF donation.FINDFIRST() THEN BEGIN
//                 //  REPEAT
//                 //    n+=1;
//                 //    //out.WRITETEXT('HOLA');
//                 //
//                 //    OutputFile.WRITE('HOLA');
//                 //
//                 //  UNTIL donation.NEXT=0;
//                 //  MESSAGE(FORMAT(n));
//                 //
//                 // END;
//                 CLEAR(OutputFile);

//                 IF OutputFile.CREATE('C:\Users\SPU2007025339\test.txt') THEN BEGIN
//                     MESSAGE('%1 is created', 'The file');
//                 END
//                 ELSE
//                     ERROR('The file could not be created')
//             end;
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     var
//         OutputFile: File;
//         donation2: Record Donation;
//         NumeroDon: Code[20];
//         FechaRegistro: Date;
//         Importe: Decimal;
//         out: OutStream;
//         n: Integer;
// }
