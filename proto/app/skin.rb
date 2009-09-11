class Raw::Element

class Page < Raw::Element
  def doctype
    %{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">}
  end

  def head
    %{
    <head profile="http://gmpg.org/xfn/11">
      <title>Nitro</title>
    	<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
    	<meta name="generator" content="Nitro" />
      <meta name="description" content="Nitro Web Framework" />        
      <link href="/css/screen.css" media="screen" rel="Stylesheet" type="text/css" />
      <script src="/js/jquery.js" type="text/javascript">/**/</script>
    </head>
    }
  end
  
  def header
    %{
    <div id="header">
    </div>
    }
  end
  
  def footer
    %{
    <div id="footer">
      &copy; #{Time.now.year}. 
    </div>
    }
  end

  def render
    %{
    #{doctype}
    <html xmlns="http://www.w3.org/1999/xhtml">
      #{head}
      <body>
        #{header}
        #{content}
        #{footer}
      </body>
    </html>
    }
  end
end

end
