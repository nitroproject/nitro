class Raw::Element

class Page < Raw::Element

  def doctype
    %{
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    }
  end

  def head
    %{
    <head profile="http://gmpg.org/xfn/11">
      <title>Nitro Blog</title>
    	<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
    	<meta name="generator" content="Nitro" />
      <meta name="description" content="The canonical Nitro example" />        
      <link href="/css/screen.css" media="screen" rel="Stylesheet" type="text/css" />
      <script src="/js/jquery.js" type="text/javascript">/**/</script>
    </head>
    }
  end
  
  def header
    %{
    <div id="header">
      <h1><a href="/">A nitrous blog</a></h1>
      This is the canonical Nitro example
    </div>
    }
  end
  
  def footer
    %{
    <div id="footer">
      &copy; #{Time.now.year} <a href="http://gmosx.com">George Moschovitis</a>. 
      Powered by <a href="http://nitroproject.org">Nitro</a>.
    </div>
    }
  end

  def endjs
    %{
    }
  end
  
  def render
    %{
    #{doctype}
    <html xmlns="http://www.w3.org/1999/xhtml">
      #{head}
      <body>
        <div id="container">
          #{header}                  
          <div id="main">
            <div id="sidebar">
              #{include "/categories/menu"}              
              #{include "/sidebox"}
            </div>
            <div id="content">
              #{content}
              <p style="clear: both" />
            </div>
          </div>
          #{footer}
        </div>
        #{endjs}
      </body>
    </html>
    }
  end

end

class Clear < Raw::Element

  def render
    %{<p style="clear: both" />}
  end

end

end
