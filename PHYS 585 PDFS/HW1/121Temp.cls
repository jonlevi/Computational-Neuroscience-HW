\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{hw121}[2016/1/18 UPenn CIS 121 homework standard LaTeX document class]

\DeclareOption*{
  \PassOptionsToClass{\CurrentOption}{article}
}
\ProcessOptions\relax
\LoadClass[letterpaper, titlepage]{article}

\RequirePackage[head=1in, bottom=1in, left=1in, right=1in]{geometry}

\RequirePackage{etoolbox}
\RequirePackage{titling}
\RequirePackage{titlesec}
\RequirePackage{fancyhdr}

\RequirePackage{hyperref}


\newcommand\thehwtype{Homework}

\newbool{@hwauthorgiven}
\newcommand\thehwauthors{\ClassError{hw}{No \protect\hwauthor given}{}}
\newcommand\hwauthor[2]{
  \ifbool{@hwauthorgiven}{
    \g@addto@macro\thehwauthors{\and #1\\\href{mailto:#2}{#2}}
    \g@addto@macro\thehwauthorsatheader{, #1}
  }{
    \renewcommand\thehwauthors{#1\\\href{mailto:#2}{#2}}
    \newcommand\thehwauthorsatheader{#1}
    \booltrue{@hwauthorgiven}
  }
}

\newcommand\thehwcourse{\ClassError{hw}{no \protect\hwcourse given}{}}
\newcommand\hwcourse[1]{\renewcommand\thehwcourse{#1}}

\newcommand\thehwrecitation{\ClassError{hw}{no \protect\hwrecitation given}{}}
\newcommand\hwrecitation[1]{\renewcommand\thehwrecitation{#1}}

\newcommand\thehwno{\ClassError{hw}{no \protect\hwno given}{}}
\newcommand\hwno[1]{\renewcommand\thehwno{#1}}

\newcommand\thehwtitle{\thehwcourse-\thehwrecitation---\thehwtype~\thehwno}

\newcommand\hwpartner[1]{
  \ifdef\thehwpartners{
    \g@addto@macro\thehwpartners{, #1}
  }{
    \newcommand\thehwpartners{#1}
  }
}

\newcommand\hwdate[0]{\date}

\newcommand\hwonelateday[0]{
  \ifdef\thehwextension{
    \renewcommand\thehwextension{\ClassError{hw}{the homework extension is already defined}{}}
  }{
    \newcommand\thehwextension{\Large Using 1 Late Day}
  }
}

\newcommand\hwtwolatedays[0]{
  \ifdef\thehwextension{
    \renewcommand\thehwextension{\ClassError{hw}{the homework extension is already defined}{}}
  }{
    \newcommand\thehwextension{\Large Using 2 Late Days}
  }
}


%
% Problem Numbering and Sectioning
%
\newcommand\hwproblemname{Problem}
\newcounter{hwproblem}

\newcommand\hwsubproblemname{Problem}
\newcounter{hwsubproblem}[hwproblem]
\renewcommand\thehwsubproblem{\thehwproblem~\alph{hwsubproblem}}

\newcommand\hwproblem{%
  \refstepcounter{hwproblem}%
  \section*{\hwproblemname~\thehwproblem}%
  \pdfbookmark[0]{\hwproblemname~\thehwproblem}{hwproblem:\arabic{hwproblem}}%
}

\newcommand\hwsubproblem{%
  \refstepcounter{hwsubproblem}%
  \subsection*{\thehwsubproblem}%
  \pdfbookmark[1]{\thehwsubproblem}{hwsubproblem:\arabic{hwproblem}.\arabic{hwsubproblem}}%
}

%
% Headers and Footers
%
\pagestyle{fancy}
\fancyhead[R]{\thehwauthorsatheader}
\fancyhead[C]{\thehwcourse-\thehwrecitation}
\fancyhead[L]{\thehwtype\ \thehwno}
\fancyfoot[R]{}
\fancyfoot[C]{\thepage}
\fancyfoot[L]{}


%
% Title
%
\author{\thehwauthors}
\title{\thehwtitle}

\renewcommand\maketitlehookc{%
  \ifdef\thehwpartners{%
    \begin{center}%
      Partners: \thehwpartners.%
    \end{center}%
  }{%
  }
}

\renewcommand\maketitlehookd{%
  \ifundef\thehwextension{%
  }{%
    \begin{center}%
      \thehwextension%
    \end{center}%
  }
}