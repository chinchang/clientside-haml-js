describe 'filters', () ->

  beforeEach () ->
      setFixtures(
        '''<script type="text/template" id="plain-filter">
           %h1
             %p
               :plain
                 Does not parse the filtered text. This is useful for large blocks of text without HTML tags,
                 when you don't want lines starting with . or - to be parsed.
             %span Other Contents
           </script>
        '''
      )

  it 'should render the result of the filter function', () ->
    html = haml.compileHaml('plain-filter')()
    expect(html).toEqual(
      '''
      <h1>
        <p>
          Does not parse the filtered text. This is useful for large blocks of text without HTML tags,
          when you don't want lines starting with . or - to be parsed.
        </p>
        <span>
          Other Contents
        </span>
      </h1>

      '''
    )

  it 'should raise an error if the filter is not found', () ->
    expect(() ->
      haml.compileStringToJs(
        '''
        %p
          :unknown
            blah di blah di blah
        '''
      )
    ).toThrow(
      '''Filter 'unknown' not registered. Filter functions need to be added to 'haml.filters'. at line 2 and character 10:
           :unknown
         ---------^'''
    )

  it 'generates javascript filters correctly', () ->
    expect(
      haml.compileCoffeeHamlFromString(
        '''
        %body
          :javascript
            // blah di blah di blah
            function () {
              return 'blah';
            }
        '''
      )()
    ).toEqual(
      '''
         <body>
           <script type="text/javascript">
           //<![CDATA[
           // blah di blah di blah
           function () {
             return 'blah';
           }
           //]]>
           </script>
         </body>
         
      '''
    )

  it 'generates css filters correctly', () ->
    expect(
      haml.compileStringToJs(
        '''
        %head
          :css
            /* blah di blah di blah */
            .body {
              color: red;
            }
        '''
      )()
    ).toEqual(
      '''
         <head>
           <style>
           //<![CDATA[
           /* blah di blah di blah */
           .body {
             color: red;
           }
           //]]>
           </style>
         </head>

      '''
    )

  it 'generates CDATA filters correctly', () ->
    expect(
      haml.compileStringToJs(
        '''
        %body
          :cdata
            // blah di blah di blah
            function () {
              return 'blah';
            }
        '''
      )()
    ).toEqual(
      '''
         <body>
           <![CDATA[
           // blah di blah di blah
           function () {
             return 'blah';
           }
           ]]>
         </body>

      '''
    )