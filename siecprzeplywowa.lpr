program siecprzeplywowa;

uses
  SysUtils;

const
  INFINITY = High(integer);

var
  i: integer;

type
  NodePointer = ^Node;

  Edge = record
    endNode: NodePointer;
    distanceToEndNode: integer;
  end;

  Node = record
    id: integer;
    edges: array of Edge;
  end;

  function createNode(id: integer; edgesCount: integer): NodePointer;
  var
    buildedNode: Node;
  begin
    buildedNode.id := id;
    SetLength(buildedNode.edges, edgesCount);
    createNode := @buildedNode;
  end;

type
  NodesList = record
    currentNode: NodePointer;
    nextNode: NodePointer;
  end;

  function hasNextNode(listOfNodes: NodesList): boolean;
  begin
    hasNextNode := listOfNodes.nextNode <> nil;
  end;

  function getValueOfParameter(parameter: string): string;
  begin
    for i := 1 to Paramcount - 1 do
      if parameter = ParamStr(i) then
      begin
        getValueOfParameter := ParamStr(i + 1);
        break;
      end;
  end;

  function getParametrizedInputFilePath(): string;
  begin
    getParametrizedInputFilePath := getValueOfParameter('-i');
  end;

  function getParametrizedOutputFileName(): string;
  begin
    getParametrizedOutputFileName := getValueOfParameter('-o');
  end;

  function getParametrizedStartNode(): string;
  begin
    getParametrizedStartNode := getValueOfParameter('-s');
  end;

  function getParametrizedEndNode(): string;
  begin
    getParametrizedEndNode := getValueOfParameter('-k');
  end;

  function hasExpectedParametersCount(): boolean;
  const
    EXPECTED_PARAMETERS_COUNT = 8;
  begin
    hasExpectedParametersCount := Paramcount = EXPECTED_PARAMETERS_COUNT;
  end;

  function getParametersAsString(): string;
  begin
    for i := 1 to Paramcount do
    begin
      getParametersAsString := getParametersAsString + ' ' + ParamStr(i);
    end;
  end;

  function containsCharInString(suspect: char; container: string): boolean;
  begin
    containsCharInString := pos(suspect, container) <> 0;
  end;

  function hasExpectedSwitches(): boolean;
  var
    parameters: string;
    expectedSwitches: array[1..4] of char = ('i', 'o', 's', 'k');
  begin
    hasExpectedSwitches := True;
    parameters := getParametersAsString();
    for i := 1 to High(expectedSwitches) do
      if not containsCharInString(expectedSwitches[i], parameters) then
      begin
        hasExpectedSwitches := False;
        break;
      end;
  end;

  function isValidFilename(filename: string): boolean;
  var
    illegalCharacters: array[1..9] of char = ('*', ':', '?', '"', '<', '>', '|', '/', '\');
  begin
    isValidFilename := True;
    for i := 1 to High(illegalCharacters) do
      if containsCharInString(illegalCharacters[i], filename) then
      begin
        isValidFilename := False;
        break;
      end;
  end;

  function isAnExistingFile(filePath: string): boolean;
  begin
    isAnExistingFile := FileExists(filePath);
  end;

  function hasParametrizedValuesSetCorrectly(): boolean;
  begin
    hasParametrizedValuesSetCorrectly := isAnExistingFile(getParametrizedInputFilePath()) and
      isValidFilename(getParametrizedOutputFileName());
  end;

  function hasParametersSetCorrectly(): boolean;
  begin
    hasParametersSetCorrectly := hasExpectedParametersCount() and hasExpectedSwitches() and
      hasParametrizedValuesSetCorrectly();
  end;

begin
  writeln('TESTS RESULTS:');
  writeln;
  writeln('PARAMETERS:');
  writeln('hasParametersSetCorrectly() resulted: ', hasParametersSetCorrectly());
  writeln('hasExpectedParametersCount() resulted: ', hasExpectedParametersCount());
  writeln('hasExpectedSwitches() resulted: ', hasExpectedSwitches());
  writeln('hasValuesSetCorrectly() resulted: ', hasParametrizedValuesSetCorrectly());
  writeln('isAnExistingFile(getParametrizedInputFilePath()) resulted: ', isAnExistingFile(
    getParametrizedInputFilePath()));
  writeln('isValidFilename(getParametrizedOutputFileName()) resulted: ', isValidFilename(
    getParametrizedOutputFileName()));
  writeln;
  writeln('Hit Enter to exit.');
  readln();
end.
