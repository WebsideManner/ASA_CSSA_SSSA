<TeXmacs|1.99.5>

<style|<tuple|beamer|ice>>

<\body>
  <screens|<\hidden>
    <tit|>

    <doc-data|<doc-title|Making Sense of the Mixed Model Analyses Available
    in R>|<doc-author|<author-data|<author-name|Peter
    Claussen>|<\author-affiliation>
      Gyling Data Management
    </author-affiliation>>>>

    \ 
  </hidden>|<\hidden>
    <tit|>

    <\session|r|default>
      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Workflow - AOV of a Linear Model>

    Given a sequence of steps in the analysis of experimental data,

    <\itemize-dot>
      <item>Data Entry

      <item>Model Fitting

      <item>Diagnostics

      <item>Model Building

      <item>Summary Statistics

      <item>Hypothesis Testing

      <item>Presentation
    </itemize-dot>

    how easily can an unfamiliar analysis package be inserted into a familiar
    routine?
  </hidden>|<\hidden>
    <tit|Data Sets>

    \;

    <\enumerate-numeric>
      <item>Simulated Data for an RCBD with Two Missing Observations.

      <item>Series of Similar Experiments

      <item>Multi-environment Breeding Trial

      Data are from\ 

      Model: <math|Y<rsub|i j k>=\<mu\>+Loc<rsub|i> +Rep<rsub|j> (Loc<rsub|i>
      ) +Gen<rsub|k> +Loc<rsub|i>\<times\>Gen<rsub|k>+Cov+\<varepsilon\><rsub|i
      j k>>

      We also use the model from Cotes

      <em|<strong|A Bayesian Approach for Assessing the Stability of
      Genotypes<em|>><strong|>>, Jose Miguel Cotes, Jose Crossa, Adhemar
      Sanches, and Paul L. Cornelius, <with|font-shape|italic|Crop Science>.
      46:2654\U2665 (2006)

      Assume a MET with <math|a> environments, <math|r<rsub|i>> blocks in
      each environment and <math|b=\<Sigma\>r<rsub|i>>, <math|g> genotypes,
      <math|n<rsub|i>> observations in each environment, <math|m<rsub|k>> the
      number of enviroments where the <math|k<rsup|th>> genotype was
      evaluated and <math|n=\<Sigma\>n<rsub|i>> observations.

      <\equation*>
        \<b-y\> = \<b-up-X\>\<b-beta\> \<noplus\>+\<b-Z\><rsub|1>\<b-up-u\><rsub|1>
        +\<b-Z\><rsub|2>\<b-up-u\><rsub|2>+<below|<above|<big|sum>|g>|k=1>\<b-Z\><rsub|3<around*|(|k|)>>\<b-up-u\><rsub|3<around*|(|k|)>>+\<b-1\><rsub|n<rsub|i>>\<otimes\>\<b-up-e\><rsub|i>
      </equation*>

      <\eqnarray*>
        <tformat|<table|<row|<cell|\<b-beta\>
        \<noplus\>>|<cell|=>|<cell|<around*|[|\<mu\><rsub|1>,\<mu\><rsub|2>,\<ldots\>,\<mu\><rsub|g>|]>>>|<row|<cell|\<b-up-u\><rsub|1>>|<cell|\<sim\>>|<cell|\<cal-N\><around*|(|<with|font-series|bold|0>,\<sigma\><rsub|u<rsub|1>><rsup|2>|)>>>|<row|<cell|\<b-up-u\><rsub|2>>|<cell|\<sim\>>|<cell|\<cal-N\><around*|(|0,\<sigma\><rsub|u<rsub|2>><rsup|2>|)>>>|<row|<cell|\<b-up-u\><rsub|3<around*|(|k|)>>>|<cell|\<sim\>>|<cell|\<cal-N\><around*|(|0,\<sigma\><rsub|u<rsub|3<around*|(|k|)>>><rsup|2>|)>>>|<row|<cell|\<b-up-e\><rsub|i><rsub|>>|<cell|\<sim\>>|<cell|\<cal-N\><around*|(|0,\<sigma\><rsub|e<rsub|i>><rsup|2>|)>\<nocomma\>>>>>
      </eqnarray*>
    </enumerate-numeric>

    \;
  </hidden>|<\hidden>
    <tit|Data Entry (Example 1)>

    R data are commonly stored in data frames.

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7 \<less\>- data.frame(

        \ \ \ \ \ \ \ \ plot = c(101,102,103,104,105,106,201,202,203,204,205,206,301,302,303,

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 304,305,306,401,402,403,404,405,406),

        \ \ \ \ \ \ \ \ rep = as.factor(c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4)),

        \ \ \ \ \ \ \ \ col = as.factor(c(1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6)),

        \ \ \ \ \ \ \ \ trt = as.factor(c(4,5,6,3,1,2,6,4,2,5,3,1,2,3,1,6,5,4,3,6,2,5,4,1)),

        \ \ \ \ \ \ \ \ obs = c(3.43,5.25,6.47,2.8,NA,2.66,8.43,6.09,6.41,5.69,7.04,NA,6.07,

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.19,4.93,5.95,4.99,3.26,5.22,7.35,4.48,6.34,6.71,3.13))

        #some packages choke on missing values

        Table5.7 \<less\>- subset(Table5.7, !is.na(Table5.7$obs))
      <|unfolded-io>
        Table5.7 \<less\>- data.frame(

        + \ \ \ \ \ \ \ \ plot = c(101,102,103,104,105,106,201,202,203,204,205,206,301,302,30

        \<less\>103,104,105,106,201,202,203,204,205,206,301,302,303,

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 304,305,306,401,402,403,404,405,406),

        + \ \ \ \ \ \ \ \ rep = as.factor(c(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4))

        \<less\>(1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4)),

        + \ \ \ \ \ \ \ \ col = as.factor(c(1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6))

        \<less\>(1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6)),

        + \ \ \ \ \ \ \ \ trt = as.factor(c(4,5,6,3,1,2,6,4,2,5,3,1,2,3,1,6,5,4,3,6,2,5,4,1))

        \<less\>(4,5,6,3,1,2,6,4,2,5,3,1,2,3,1,6,5,4,3,6,2,5,4,1)),

        + \ \ \ \ \ \ \ \ obs = c(3.43,5.25,6.47,2.8,NA,2.66,8.43,6.09,6.41,5.69,7.04,NA,6.07

        \<less\>,6.47,2.8,NA,2.66,8.43,6.09,6.41,5.69,7.04,NA,6.07,

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.19,4.93,5.95,4.99,3.26,5.22,7.35,4.48,6.34,6.71,3.13))

        \<gtr\> #some packages choke on missing values

        \<gtr\> Table5.7 \<less\>- subset(Table5.7, !is.na(Table5.7$obs))
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7.treatments \<less\>- length(levels(Table5.7$trt))
      <|unfolded-io>
        Table5.7.treatments \<less\>- length(levels(Table5.7$trt))
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Data Entry (Example 2)>

    For structured data, factors can be added programmatically.

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1 \<less\>- data.frame(

        Trial=as.factor(c(rep("Clayton", 36),

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("Clinton", 36),

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("Plymouth", 36))),

        Variety=as.factor(rep(

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ c(rep("Tracy", 3),
        rep("Centennial", 3),\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N72-137", 3),
        rep("N72-3058", 3),\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N72-3148", 3),
        rep("R73-81", 3),\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("D74-7741", 3),
        rep("N73-693", 3),\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N73-877", 3),
        rep("N73-882", 3),\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N73-1102", 3),
        rep("R75-12", 3)),

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 3)),

        Rep=as.factor(rep(c(1, 2, 3),36)),

        Yield=c(1178, 1089, 960, 1187, 1180, 1235, 1451, 1177, 1723, 1318,
        1012, 990,\ 

        \ \ \ \ \ \ \ \ 1345, 1335, 1303, 1175, 1064, 1158, 1111, 1111, 1099,
        1388, 1214, 1222,

        \ \ \ \ \ \ \ \ 1254, 1249, 1135, 1179, 1247, 1096, 1345, 1265, 1178,
        1136, 1161, 1004,

        \ \ \ \ \ \ \ \ 1583, 1841, 1464, 1713, 1684, 1378, 1369, 1608, 1647,
        1547, 1647, 1603,

        \ \ \ \ \ \ \ \ 1622, 1801, 1929, 1800, 1787, 1520, 1820, 1521, 1851,
        1464, 1607, 1642,

        \ \ \ \ \ \ \ \ 1775, 1513, 1570, 1673, 1507, 1390, 1894, 1547, 1751,
        1422, 1393, 1342,

        \ \ \ \ \ \ \ \ 1307, 1365, 1542, 1425, 1475, 1276, 1289, 1671, 1420,
        1250, 1202, 1407,

        \ \ \ \ \ \ \ \ 1546, 1489, 1724, 1344, 1197, 1319, 1280, 1260, 1605,
        1583, 1503, 1303,

        \ \ \ \ \ \ \ \ 1656, 1371, 1107, 1398, 1497, 1583, 1586, 1423,
        \ 1524, 911, 1202, 1012 \ \ \ \ \ \ \ \ \ ))

        \;
      <|unfolded-io>
        Ex16.8.1 \<less\>- data.frame(

        + Trial=as.factor(c(rep("Clayton", 36),

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("Clinton", 36),

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("Plymouth", 36))),

        + Variety=as.factor(rep(

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ c(rep("Tracy", 3),
        rep("Centennial", 3),\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N72-137", 3),
        rep("N72-3058", 3),\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N72-3148", 3),
        rep("R73-81", 3),\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("D74-7741", 3),
        rep("N73-693", 3),\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N73-877", 3),
        rep("N73-882", 3),\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ rep("N73-1102", 3),
        rep("R75-12", 3)),

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 3)),

        + Rep=as.factor(rep(c(1, 2, 3),36)),

        + Yield=c(1178, 1089, 960, 1187, 1180, 1235, 1451, 1177, 1723, 1318,
        1012, 99

        \<less\>1187, 1180, 1235, 1451, 1177, 1723, 1318, 1012, 990,\ 

        + \ \ \ \ \ \ \ \ 1345, 1335, 1303, 1175, 1064, 1158, 1111, 1111,
        1099, 1388, 1214, 1

        \<less\> 1175, 1064, 1158, 1111, 1111, 1099, 1388, 1214, 1222,

        + \ \ \ \ \ \ \ \ 1254, 1249, 1135, 1179, 1247, 1096, 1345, 1265,
        1178, 1136, 1161, 1

        \<less\> 1179, 1247, 1096, 1345, 1265, 1178, 1136, 1161, 1004,

        + \ \ \ \ \ \ \ \ 1583, 1841, 1464, 1713, 1684, 1378, 1369, 1608,
        1647, 1547, 1647, 1

        \<less\> 1713, 1684, 1378, 1369, 1608, 1647, 1547, 1647, 1603,

        + \ \ \ \ \ \ \ \ 1622, 1801, 1929, 1800, 1787, 1520, 1820, 1521,
        1851, 1464, 1607, 1

        \<less\> 1800, 1787, 1520, 1820, 1521, 1851, 1464, 1607, 1642,

        + \ \ \ \ \ \ \ \ 1775, 1513, 1570, 1673, 1507, 1390, 1894, 1547,
        1751, 1422, 1393, 1

        \<less\> 1673, 1507, 1390, 1894, 1547, 1751, 1422, 1393, 1342,

        + \ \ \ \ \ \ \ \ 1307, 1365, 1542, 1425, 1475, 1276, 1289, 1671,
        1420, 1250, 1202, 1

        \<less\> 1425, 1475, 1276, 1289, 1671, 1420, 1250, 1202, 1407,

        + \ \ \ \ \ \ \ \ 1546, 1489, 1724, 1344, 1197, 1319, 1280, 1260,
        1605, 1583, 1503, 1

        \<less\> 1344, 1197, 1319, 1280, 1260, 1605, 1583, 1503, 1303,

        + \ \ \ \ \ \ \ \ 1656, 1371, 1107, 1398, 1497, 1583, 1586, 1423,
        \ 1524, 911, 1202, 1

        \<less\> 1398, 1497, 1583, 1586, 1423, \ 1524, 911, 1202, 1012
        \ \ \ \ \ \ \ \ \ ))

        \<gtr\>\ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.treatments \<less\>- length(levels(Ex16.8.1$Variety))
      <|unfolded-io>
        Ex16.8.1.treatments \<less\>- length(levels(Ex16.8.1$Variety))
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Data Entry (Example 3)>

    Example 3 comes from ... . It's a large data set, so it's simpler to load
    from a file.

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        setwd("~/Work/git/ASA_CSSA_SSSA/literate")

        rcbd.dat \<less\>- read.csv("sample RCBD data.csv",header=TRUE)
      <|unfolded-io>
        setwd("~/Work/git/ASA_CSSA_SSSA/literate")

        \<gtr\> rcbd.dat \<less\>- read.csv("sample RCBD
        data.csv",header=TRUE)
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        head(rcbd.dat)
      <|unfolded-io>
        head(rcbd.dat)

        \ \ Site Country \ \ \ \ Loca Plot Repe BLK Entry \ YLD AD SD \ PH
        \ EH rEPH rEPP nP

        1 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 1 \ \ \ 1 \ \ 1 \ \ \ 21 7.00 54 55
        280 150 0.54 \ 0.9 58

        2 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 2 \ \ \ 1 \ \ 1 \ \ \ 22 8.39 51 52
        270 140 0.52 \ \ \ 1 58

        3 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 3 \ \ \ 1 \ \ 1 \ \ \ 32 6.85 52 53
        265 140 0.53 \ 0.9 54

        4 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 4 \ \ \ 1 \ \ 1 \ \ \ 11 8.09 53 54
        275 140 0.51 \ \ \ 1 53

        5 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 5 \ \ \ 1 \ \ 2 \ \ \ \ 4 6.86 51
        52 260 125 0.48 \ 0.9 58

        6 \ \ \ 3 \ Mexico Cotaxtla \ \ \ 6 \ \ \ 1 \ \ 2 \ \ \ 29 6.45 51 52
        275 130 0.47 \ 0.9 57
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Model Fitting>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7.lm \<less\>- lm(obs ~ 0 + trt + rep, data = Table5.7)
      <|unfolded-io>
        Table5.7.lm \<less\>- lm(obs ~ 0 + trt + rep, data = Table5.7)
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    Traditionally, MET have been analyzed using analysis of variance based on
    ordinary least methods. Briefly, we define the linear system of equations

    <\equation*>
      <tabular|<tformat|<table|<row|<cell|\<b-up-y\>>|<cell|=>|<cell|\<b-up-X\>\<b-beta\>
      \<noplus\>+\<b-up-e\>>>>>>
    </equation*>

    where <math|\<b-up-X\>> defines the design of the experiment,
    <math|\<b-up-y\>> are observed values and <math|\<b-beta\>> are
    parameters of interest (i.e. variety means). Estimates are found by

    <\equation*>
      <wide|\<b-beta\>|^>=<around*|(|\<b-up-X\><rsup|t>\<b-up-X\>|)><rsup|-1>\<b-up-X\><rsup|t>\<b-up-y\>
    </equation*>

    minimizing

    <\equation*>
      \<Sigma\>\<b-up-e\><rsub|i><rsup|2>=\<b-up-e\><rsup|t>\<b-up-e\>=<around*|(|\<b-up-y\>-\<b-up-X\>\<b-beta\>|)><rsup|t><around*|(|\<b-up-y\>-\<b-up-X\>\<b-beta\>|)>
    </equation*>
  </hidden>|<\hidden>
    <tit|Diagnostics>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        par(mfrow = c(2, 2))\ 

        plot(Table5.7.lm)

        par(mfrow = c(1,1));v()
      <|unfolded-io>
        par(mfrow = c(2, 2))\ 

        \<gtr\> plot(Table5.7.lm)
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|Model Building>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7.red.lm \<less\>- update(Table5.7.lm, . ~ . - trt)
      <|unfolded-io>
        Table5.7.red.lm \<less\>- update(Table5.7.lm, . ~ . - trt)
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Summary Statistics>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(Table5.7.lm)
      <|unfolded-io>
        summary(Table5.7.lm)

        \;

        Call:

        lm(formula = obs ~ 0 + trt + rep, data = Table5.7)

        \;

        Residuals:

        \ \ \ \ \ Min \ \ \ \ \ \ 1Q \ \ Median \ \ \ \ \ \ 3Q \ \ \ \ \ Max\ 

        -1.57367 -0.79233 \ 0.02958 \ 0.76387 \ 1.56967\ 

        \;

        Coefficients:

        \ \ \ \ \ Estimate Std. Error t value Pr(\<gtr\>\|t\|) \ \ \ 

        trt1 \ \ 2.4960 \ \ \ \ 1.0255 \ \ 2.434 0.030112 * \ 

        trt2 \ \ 3.4855 \ \ \ \ 0.7252 \ \ 4.807 0.000343 ***

        trt3 \ \ 3.8930 \ \ \ \ 0.7252 \ \ 5.368 0.000128 ***

        trt4 \ \ 3.4530 \ \ \ \ 0.7252 \ \ 4.762 0.000372 ***

        trt5 \ \ 4.1480 \ \ \ \ 0.7252 \ \ 5.720 7.05e-05 ***

        trt6 \ \ 5.6305 \ \ \ \ 0.7252 \ \ 7.764 3.10e-06 ***

        rep2 \ \ 2.6100 \ \ \ \ 0.7252 \ \ 3.599 0.003237 **\ 

        rep3 \ \ 1.3807 \ \ \ \ 0.7099 \ \ 1.945 0.073742 . \ 

        rep4 \ \ 1.6873 \ \ \ \ 0.7099 \ \ 2.377 0.033502 * \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        \;

        Residual standard error: 1.147 on 13 degrees of freedom

        Multiple R-squared: \ 0.9754, \ \ \ Adjusted R-squared: \ 0.9583\ 

        F-statistic: 57.21 on 9 and 13 DF, \ p-value: 5.409e-09

        \;
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Summary Statistics (AOV)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        anova(Table5.7.lm)

        anova(Table5.7.red.lm,Table5.7.lm)
      <|unfolded-io>
        anova(Table5.7.lm)

        Analysis of Variance Table

        \;

        Response: obs

        \ \ \ \ \ \ \ \ \ \ Df Sum Sq Mean Sq F value \ \ Pr(\<gtr\>F) \ \ \ 

        trt \ \ \ \ \ \ \ 6 659.37 109.895 83.5934 1.26e-09 ***

        rep \ \ \ \ \ \ \ 3 \ 17.57 \ \ 5.858 \ 4.4561 \ 0.02316 * \ 

        Residuals 13 \ 17.09 \ \ 1.315 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        \<gtr\> anova(Table5.7.red.lm,Table5.7.lm)

        Analysis of Variance Table

        \;

        Model 1: obs ~ rep - 1

        Model 2: obs ~ 0 + trt + rep

        \ \ Res.Df \ \ \ RSS Df Sum of Sq \ \ \ \ \ F \ Pr(\<gtr\>F) \ 

        1 \ \ \ \ 18 34.222 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        2 \ \ \ \ 13 17.090 \ 5 \ \ \ 17.132 2.6063 0.07619 .

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Summary Statistics (Covariance)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        vcov(Table5.7.lm)
      <|unfolded-io>
        vcov(Table5.7.lm)

        \ \ \ \ \ \ \ \ \ \ \ trt1 \ \ \ \ \ \ trt2 \ \ \ \ \ \ trt3
        \ \ \ \ \ \ trt4 \ \ \ \ \ \ trt5 \ \ \ \ \ \ trt6

        trt1 \ 1.0517130 \ 0.2629283 \ 0.2629283 \ 0.2629283 \ 0.2629283
        \ 0.2629283

        trt2 \ 0.2629283 \ 0.5258565 \ 0.1971962 \ 0.1971962 \ 0.1971962
        \ 0.1971962

        trt3 \ 0.2629283 \ 0.1971962 \ 0.5258565 \ 0.1971962 \ 0.1971962
        \ 0.1971962

        trt4 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.5258565 \ 0.1971962
        \ 0.1971962

        trt5 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.1971962 \ 0.5258565
        \ 0.1971962

        trt6 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.1971962 \ 0.1971962
        \ 0.5258565

        rep2 -0.2629283 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        rep3 -0.3943924 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        rep4 -0.3943924 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        \ \ \ \ \ \ \ \ \ \ \ rep2 \ \ \ \ \ \ rep3 \ \ \ \ \ \ rep4

        trt1 -0.2629283 -0.3943924 -0.3943924

        trt2 -0.2629283 -0.2629283 -0.2629283

        trt3 -0.2629283 -0.2629283 -0.2629283

        trt4 -0.2629283 -0.2629283 -0.2629283

        trt5 -0.2629283 -0.2629283 -0.2629283

        trt6 -0.2629283 -0.2629283 -0.2629283

        rep2 \ 0.5258565 \ 0.2629283 \ 0.2629283

        rep3 \ 0.2629283 \ 0.5039458 \ 0.2848389

        rep4 \ 0.2629283 \ 0.2848389 \ 0.5039458
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Hypothesis Testing>

    The multcomp package provides an interface for multiple tests and allows
    for user specified contrasts. This package assumes both coef and vcov are
    available for a given model.

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        library(multcomp)

        summary(glht(Table5.7.lm,linfct=mcp(trt="Dunnett")))
      <|unfolded-io>
        library(multcomp)

        Loading required package: mvtnorm

        Loading required package: survival

        Loading required package: TH.data

        Loading required package: MASS

        \;

        Attaching package: 'TH.data'

        \;

        The following object is masked from 'package:MASS':

        \;

        \ \ \ \ geyser

        \;

        \<gtr\> summary(glht(Table5.7.lm,linfct=mcp(trt="Dunnett")))

        \;

        \ \ \ \ \ \ \ \ \ Simultaneous Tests for General Linear Hypotheses

        \;

        Multiple Comparisons of Means: Dunnett Contrasts

        \;

        \;

        Fit: lm(formula = obs ~ 0 + trt + rep, data = Table5.7)

        \;

        Linear Hypotheses:

        \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error t value Pr(\<gtr\>\|t\|) \ 

        2 - 1 == 0 \ \ 0.9895 \ \ \ \ 1.0255 \ \ 0.965 \ \ 0.7220 \ 

        3 - 1 == 0 \ \ 1.3970 \ \ \ \ 1.0255 \ \ 1.362 \ \ 0.4644 \ 

        4 - 1 == 0 \ \ 0.9570 \ \ \ \ 1.0255 \ \ 0.933 \ \ 0.7430 \ 

        5 - 1 == 0 \ \ 1.6520 \ \ \ \ 1.0255 \ \ 1.611 \ \ 0.3320 \ 

        6 - 1 == 0 \ \ 3.1345 \ \ \ \ 1.0255 \ \ 3.056 \ \ 0.0297 *

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        (Adjusted p values reported -- single-step method)

        \;
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        cld(glht(Table5.7.lm,linfct=mcp(trt="Tukey")),decreasing=TRUE)
      <|unfolded-io>
        cld(glht(Table5.7.lm,linfct=mcp(trt="Tukey")),decreasing=TRUE)

        \ \ 1 \ \ 2 \ \ 3 \ \ 4 \ \ 5 \ \ 6\ 

        "a" "a" "a" "a" "a" "a"\ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(glht(Table5.7.lm,linfct=mcp(trt="Tukey"))
      <|unfolded-io>
        summary(glht(Table5.7.lm,linfct=mcp(trt="Tukey"))
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|+ >
      <|unfolded-io>
        )
      <|unfolded-io>
        )

        \;

        \ \ \ \ \ \ \ \ \ Simultaneous Tests for General Linear Hypotheses

        \;

        Multiple Comparisons of Means: Tukey Contrasts

        \;

        \;

        Fit: lm(formula = obs ~ 0 + trt + rep, data = Table5.7)

        \;

        Linear Hypotheses:

        \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error t value Pr(\<gtr\>\|t\|) \ 

        2 - 1 == 0 \ \ 0.9895 \ \ \ \ 1.0255 \ \ 0.965 \ \ 0.9201 \ 

        3 - 1 == 0 \ \ 1.3970 \ \ \ \ 1.0255 \ \ 1.362 \ \ 0.7448 \ 

        4 - 1 == 0 \ \ 0.9570 \ \ \ \ 1.0255 \ \ 0.933 \ \ 0.9297 \ 

        5 - 1 == 0 \ \ 1.6520 \ \ \ \ 1.0255 \ \ 1.611 \ \ 0.6029 \ 

        6 - 1 == 0 \ \ 3.1345 \ \ \ \ 1.0255 \ \ 3.056 \ \ 0.0772 .

        3 - 2 == 0 \ \ 0.4075 \ \ \ \ 0.8107 \ \ 0.503 \ \ 0.9951 \ 

        4 - 2 == 0 \ -0.0325 \ \ \ \ 0.8107 \ -0.040 \ \ 1.0000 \ 

        5 - 2 == 0 \ \ 0.6625 \ \ \ \ 0.8107 \ \ 0.817 \ \ 0.9585 \ 

        6 - 2 == 0 \ \ 2.1450 \ \ \ \ 0.8107 \ \ 2.646 \ \ 0.1521 \ 

        4 - 3 == 0 \ -0.4400 \ \ \ \ 0.8107 \ -0.543 \ \ 0.9930 \ 

        5 - 3 == 0 \ \ 0.2550 \ \ \ \ 0.8107 \ \ 0.315 \ \ 0.9995 \ 

        6 - 3 == 0 \ \ 1.7375 \ \ \ \ 0.8107 \ \ 2.143 \ \ 0.3222 \ 

        5 - 4 == 0 \ \ 0.6950 \ \ \ \ 0.8107 \ \ 0.857 \ \ 0.9496 \ 

        6 - 4 == 0 \ \ 2.1775 \ \ \ \ 0.8107 \ \ 2.686 \ \ 0.1426 \ 

        6 - 5 == 0 \ \ 1.4825 \ \ \ \ 0.8107 \ \ 1.829 \ \ 0.4790 \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        (Adjusted p values reported -- single-step method)

        \;
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Presentation>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        library(lsmeans)

        lsmeans(Table5.7.lm,cld ~ trt)
      <|unfolded-io>
        library(lsmeans)

        Loading required package: estimability

        \<gtr\> lsmeans(Table5.7.lm,cld ~ trt)

        \ trt lsmean \ \ \ \ \ \ \ SE df lower.CL upper.CL .group

        \ 1 \ \ 3.9155 0.8503251 13 2.078484 5.752516 \ 1 \ \ \ 

        \ 4 \ \ 4.8725 0.5732890 13 3.633984 6.111016 \ 1 \ \ \ 

        \ 2 \ \ 4.9050 0.5732890 13 3.666484 6.143516 \ 1 \ \ \ 

        \ 3 \ \ 5.3125 0.5732890 13 4.073984 6.551016 \ 1 \ \ \ 

        \ 5 \ \ 5.5675 0.5732890 13 4.328984 6.806016 \ 1 \ \ \ 

        \ 6 \ \ 7.0500 0.5732890 13 5.811484 8.288516 \ 1 \ \ \ 

        \;

        Results are averaged over the levels of: rep\ 

        Confidence level used: 0.95\ 

        P value adjustment: tukey method for comparing a family of 6
        estimates\ 

        significance level used: alpha = 0.05\ 
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Presentation (Graphic)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        library(ggplot2)

        cbPalette \<less\>- c("#999999", "#E69F00", "#56B4E9", "#009E73",
        "#0072B2", "#D55E00",\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "#F0E442", "#CC79A7", "#734f80",
        "#2b5a74", "#004f39", "#787221",\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "#003959", "#6aaf00", "#663cd3",
        "#000000")
      <|unfolded-io>
        library(ggplot2)

        \<gtr\> cbPalette \<less\>- c("#999999", "#E69F00", "#56B4E9",
        "#009E73", "#0072B2", "#D55

        \<less\> "#E69F00", "#56B4E9", "#009E73", "#0072B2", "#D55E00",\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "#F0E442", "#CC79A7", "#734f80",
        "#2b5a74", "#004f39", "#787

        \<less\> "#CC79A7", "#734f80", "#2b5a74", "#004f39", "#787221",\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ "#003959", "#6aaf00", "#663cd3",
        "#000000")
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        make.plot.table \<less\>- function(model,form=NULL,effect=NULL) {

        \ \ \ if(is.null(effect)) {

        \ \ \ \ \ \ effect \<less\>- "trt"

        \ \ \ }

        \ \ \ if(is.null(form)) {

        \ \ \ \ \ \ form \<less\>- formula(paste("cld ~ ",effect))

        \ \ \ }

        \ \ \ model.tbl \<less\>- lsmeans(model,form)

        \ \ \ mcp.list \<less\>- list(effect="Tukey")

        \ \ \ names(mcp.list) \<less\>- effect

        \ \ \ attr(mcp.list, "interaction_average") \<less\>- TRUE

        \ \ \ attr(mcp.list, "covariate_average") \<less\>- TRUE

        \ \ \ class(mcp.list) \<less\>- "mcp"

        \ \ \ letters \<less\>- cld(glht(model,linfct=mcp.list,interaction_average
        = TRUE,\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ covariate_average
        = TRUE),

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ decreasing=TRUE)$mcletters$Letters

        \ \ \ model.tbl$letters \<less\>- letters[model.tbl[,effect]]

        \ \ \ names(model.tbl) \<less\>- c("Treatment","Mean","Error","df","Lower","Upper","Group","Letters")

        \ \ \ return(model.tbl)

        }
      <|unfolded-io>
        make.plot.table \<less\>- function(model,form=NULL,effect=NULL) {

        + \ \ \ if(is.null(effect)) {

        + \ \ \ \ \ \ effect \<less\>- "trt"

        + \ \ \ }

        + \ \ \ if(is.null(form)) {

        + \ \ \ \ \ \ form \<less\>- formula(paste("cld ~ ",effect))

        + \ \ \ }

        + \ \ \ model.tbl \<less\>- lsmeans(model,form)

        + \ \ \ mcp.list \<less\>- list(effect="Tukey")

        + \ \ \ names(mcp.list) \<less\>- effect

        + \ \ \ attr(mcp.list, "interaction_average") \<less\>- TRUE

        + \ \ \ attr(mcp.list, "covariate_average") \<less\>- TRUE

        + \ \ \ class(mcp.list) \<less\>- "mcp"

        + \ \ \ letters \<less\>- cld(glht(model,linfct=mcp.list,interaction_average
        = TRUE,\ 

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ covariate_average
        = TRUE),

        + \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ decreasing=TRUE)$mcletters$Letters

        + \ \ \ model.tbl$letters \<less\>- letters[model.tbl[,effect]]

        + \ \ \ names(model.tbl) \<less\>-
        c("Treatment","Mean","Error","df","Lower","Upper","G

        \<less\>"Treatment","Mean","Error","df","Lower","Upper","Group","Letters")

        + \ \ \ return(model.tbl)

        + }
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        plot.lsmeans.tbl \<less\>- function(model.tbl,formula=NULL,title="lm")
        {

        \ \ \ dodge \<less\>- position_dodge(width = 0.9)

        \ \ \ upper.lim \<less\>- max(model.tbl$Upper)

        \ \ \ upper.lim \<less\>- \ upper.lim + 0.1*upper.lim\ 

        \ \ \ limits \<less\>- aes(ymax = model.tbl$Upper, ymin =
        model.tbl$Lower)

        \ \ \ return(ggplot(data = model.tbl, aes(x = Treatment, y = Mean,
        fill = Treatment)) +\ 

        \ \ \ \ \ geom_bar(stat = "identity", position = dodge) +

        \ \ \ \ \ coord_cartesian(ylim = c(min(model.tbl$Lower),upper.lim)) +

        \ \ \ \ \ geom_errorbar(limits, position = dodge, width = 0.25) +

        \ \ \ \ \ theme(legend.position = "none") + ggtitle(title) +\ 

        \ \ \ \ \ scale_fill_manual(values=cbPalette) +

        \ \ \ \ \ geom_text(aes(x=model.tbl$Treatment,y=upper.lim,label=Letters))

        \ \ \ )

        }

        plot.lsmeans \<less\>- function(model,form=NULL,effect=NULL,title="lm")
        {

        \ \ \ return(

        \ \ \ \ \ \ plot.lsmeans.tbl(

        \ \ \ \ \ \ \ \ \ make.plot.table(model,form=form,effect=effect),formula=formula,title=title))

        }
      <|unfolded-io>
        plot.lsmeans.tbl \<less\>- function(model.tbl,formula=NULL,title="lm")
        {

        + \ \ \ dodge \<less\>- position_dodge(width = 0.9)

        + \ \ \ upper.lim \<less\>- max(model.tbl$Upper)

        + \ \ \ upper.lim \<less\>- \ upper.lim + 0.1*upper.lim\ 

        + \ \ \ limits \<less\>- aes(ymax = model.tbl$Upper, ymin =
        model.tbl$Lower)

        + \ \ \ return(ggplot(data = model.tbl, aes(x = Treatment, y = Mean,
        fill = Trea

        \<less\>odel.tbl, aes(x = Treatment, y = Mean, fill = Treatment)) +\ 

        + \ \ \ \ \ geom_bar(stat = "identity", position = dodge) +

        + \ \ \ \ \ coord_cartesian(ylim = c(min(model.tbl$Lower),upper.lim))
        +

        + \ \ \ \ \ geom_errorbar(limits, position = dodge, width = 0.25) +

        + \ \ \ \ \ theme(legend.position = "none") + ggtitle(title) +\ 

        + \ \ \ \ \ scale_fill_manual(values=cbPalette) +

        + \ \ \ \ \ geom_text(aes(x=model.tbl$Treatment,y=upper.lim,label=Letters))

        + \ \ \ )

        + }

        \<gtr\> plot.lsmeans \<less\>- function(model,form=NULL,effect=NULL,title="lm")
        {

        + \ \ \ return(

        + \ \ \ \ \ \ plot.lsmeans.tbl(

        + \ \ \ \ \ \ \ \ \ make.plot.table(model,form=form,effect=effect),formula=formula,tit

        \<less\>model,form=form,effect=effect),formula=formula,title=title))

        + }
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Presentation (Graphic)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7.lm.tbl \<less\>- make.plot.table(Table5.7.lm)

        Table5.7.lm.plot \<less\>- plot.lsmeans.tbl(Table5.7.lm.tbl)

        Table5.7.lm.plot;v()
      <|unfolded-io>
        Table5.7.lm.tbl \<less\>- make.plot.table(Table5.7.lm)

        \<gtr\> Table5.7.lm.plot \<less\>- plot.lsmeans.tbl(Table5.7.lm.tbl)

        \<gtr\> Table5.7.lm.plot;v()

        <image|<tuple|<#252150532D41646F62652D332E3020455053462D332E300A2525446F63756D656E744E65656465645265736F75726365733A20666F6E742048656C7665746963610A25252B20666F6E742048656C7665746963612D426F6C640A25252B20666F6E742048656C7665746963612D4F626C697175650A25252B20666F6E742048656C7665746963612D426F6C644F626C697175650A25252B20666F6E742053796D626F6C0A25255469746C653A2052204772617068696373204F75747075740A252543726561746F723A205220536F6674776172650A252550616765733A20286174656E64290A2525426F756E64696E67426F783A2030203020323838203238380A2525456E64436F6D6D656E74730A2525426567696E50726F6C6F670A2F627020207B2067732073524742206773207D206465660A2520626567696E202E70732E70726F6C6F670A2F677320207B206773617665207D2062696E64206465660A2F677220207B2067726573746F7265207D2062696E64206465660A2F657020207B2073686F7770616765206772206772207D2062696E64206465660A2F6D2020207B206D6F7665746F207D2062696E64206465660A2F6C20207B20726C696E65746F207D2062696E64206465660A2F6E7020207B206E657770617468207D2062696E64206465660A2F637020207B20636C6F736570617468207D2062696E64206465660A2F662020207B2066696C6C207D2062696E64206465660A2F6F2020207B207374726F6B65207D2062696E64206465660A2F632020207B206E65777061746820302033363020617263207D2062696E64206465660A2F722020207B2034203220726F6C6C206D6F7665746F203120636F70792033202D3120726F6C6C20657863682030206578636820726C696E65746F203020726C696E65746F202D31206D756C2030206578636820726C696E65746F20636C6F736570617468207D2062696E64206465660A2F703120207B207374726F6B65207D2062696E64206465660A2F703220207B2067736176652062672066696C6C2067726573746F7265206E657770617468207D2062696E64206465660A2F703320207B2067736176652062672066696C6C2067726573746F7265207374726F6B65207D2062696E64206465660A2F703620207B20677361766520626720656F66696C6C2067726573746F7265206E657770617468207D2062696E64206465660A2F703720207B20677361766520626720656F66696C6C2067726573746F7265207374726F6B65207D2062696E64206465660A2F742020207B2035202D3220726F6C6C206D6F7665746F20677361766520726F746174650A202020202020203120696E64657820737472696E67776964746820706F700A202020202020206D756C206E6567203020726D6F7665746F2073686F772067726573746F7265207D2062696E64206465660A2F746120207B2034202D3220726F6C6C206D6F7665746F20677361766520726F746174652073686F77207D2062696E64206465660A2F746220207B2032202D3120726F6C6C203020726D6F7665746F2073686F77207D2062696E64206465660A2F636C20207B2067726573746F7265206773617665206E657770617468203320696E646578203320696E646578206D6F7665746F203120696E6465780A2020202020202034202D3120726F6C6C206C696E65746F202065786368203120696E646578206C696E65746F206C696E65746F0A20202020202020636C6F73657061746820636C6970206E657770617468207D2062696E64206465660A2F726762207B20736574726762636F6C6F72207D2062696E64206465660A2F732020207B207363616C65666F6E7420736574666F6E74207D2062696E64206465660A2520656E642020202E70732E70726F6C6F670A2F73524742207B205B202F43494542617365644142430A202020202020202020203C3C202F4465636F64654C4D4E0A2020202020202020202020202020205B207B2064757020302E3033393238206C650A2020202020202020202020202020202020202020202020207B31322E3932333231206469767D0A2020202020202020202020202020202020202020202020207B302E3035352061646420312E3035352064697620322E3420657870207D0A2020202020202020202020202020202020202020206966656C73650A20202020202020202020202020202020207D2062696E6420647570206475700A2020202020202020202020202020205D0A202020202020202020202020202F4D61747269784C4D4E205B302E34313234353720302E32313236373320302E3031393333340A20202020202020202020202020202020202020202020202020302E33353735373620302E37313531353220302E3131393139320A20202020202020202020202020202020202020202020202020302E31383034333720302E30373231373520302E3935303330315D0A202020202020202020202020202F5768697465506F696E74205B302E3935303520312E3020312E303839305D0A20202020202020202020203E3E0A2020202020202020205D20736574636F6C6F727370616365207D2062696E64206465660A2F73726762207B20736574636F6C6F72207D2062696E64206465660A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963610A2F48656C7665746963612066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7431206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D426F6C640A2F48656C7665746963612D426F6C642066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7432206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D4F626C697175650A2F48656C7665746963612D4F626C697175652066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7433206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D426F6C644F626C697175650A2F48656C7665746963612D426F6C644F626C697175652066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7434206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742053796D626F6C0A2F53796D626F6C2066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A202063757272656E74646963740A2020656E640A2F466F6E7435206578636820646566696E65666F6E7420706F700A2525456E6450726F6C6F670A2525506167653A203120310A62700A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F6267207B2031203120312073726762207D206465660A312031203120737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A31207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A302E303020302E3030203238382E3030203238382E303020722070330A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A32392E38392033312E3335203238322E3532203236362E363120636C0A2F6267207B20302E3932313620302E3932313620302E393231362073726762207D206465660A32392E38392033312E3335203235322E3633203233352E323620722070320A312031203120737267620A302E3533207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A32392E38392037302E3034206D0A3235322E36332030206C0A6F0A6E700A32392E3839203133302E3831206D0A3235322E36332030206C0A6F0A6E700A32392E3839203139312E3538206D0A3235322E36332030206C0A6F0A6E700A32392E3839203235322E3335206D0A3235322E36332030206C0A6F0A312E3037207365746C696E6577696474680A5B5D203020736574646173680A6E700A32392E38392033392E3636206D0A3235322E36332030206C0A6F0A6E700A32392E3839203130302E3433206D0A3235322E36332030206C0A6F0A6E700A32392E3839203136312E3230206D0A3235322E36332030206C0A6F0A6E700A32392E3839203232312E3937206D0A3235322E36332030206C0A6F0A6E700A35342E33342033312E3335206D0A30203233352E3236206C0A6F0A6E700A39352E30382033312E3335206D0A30203233352E3236206C0A6F0A6E700A3133352E38332033312E3335206D0A30203233352E3236206C0A6F0A6E700A3137362E35382033312E3335206D0A30203233352E3236206C0A6F0A6E700A3231372E33332033312E3335206D0A30203233352E3236206C0A6F0A6E700A3235382E30372033312E3335206D0A30203233352E3236206C0A6F0A2F6267207B20302E3630303020302E3630303020302E363030302073726762207D206465660A33362E3030202D32312E31312033362E3637203131382E393720722070320A2F6267207B20302E3930323020302E3632333520302073726762207D206465660A37362E3735202D32312E31312033362E3637203134392E303420722070320A2F6267207B20302E3333373320302E3730353920302E393133372073726762207D206465660A3131372E3439202D32312E31312033362E3637203136312E343220722070320A2F6267207B203020302E3631393620302E343531302073726762207D206465660A3135382E3234202D32312E31312033362E3637203134382E303520722070320A2F6267207B203020302E3434373120302E363938302073726762207D206465660A3139382E3939202D32312E31312033362E3637203136392E313720722070320A2F6267207B20302E3833353320302E3336383620302073726762207D206465660A3233392E3734202D32312E31312033362E3637203231342E323120722070320A302030203020737267620A312E3030207365746D697465726C696D69740A6E700A34392E3234203135332E3638206D0A31302E31392030206C0A6F0A6E700A35342E3334203135332E3638206D0A30202D3131312E3634206C0A6F0A6E700A34392E32342034322E3034206D0A31302E31392030206C0A6F0A6E700A38392E3939203136352E3536206D0A31302E31392030206C0A6F0A6E700A39352E3038203136352E3536206D0A30202D37352E3237206C0A6F0A6E700A38392E39392039302E3239206D0A31302E31392030206C0A6F0A6E700A3133302E3734203137372E3934206D0A31302E31382030206C0A6F0A6E700A3133352E3833203137372E3934206D0A30202D37352E3237206C0A6F0A6E700A3133302E3734203130322E3637206D0A31302E31382030206C0A6F0A6E700A3137312E3438203136342E3537206D0A31302E31392030206C0A6F0A6E700A3137362E3538203136342E3537206D0A30202D37352E3237206C0A6F0A6E700A3137312E34382038392E3330206D0A31302E31392030206C0A6F0A6E700A3231322E3233203138352E3639206D0A31302E31392030206C0A6F0A6E700A3231372E3333203138352E3639206D0A30202D37352E3237206C0A6F0A6E700A3231322E3233203131302E3432206D0A31302E31392030206C0A6F0A6E700A3235322E3938203233302E3733206D0A31302E31392030206C0A6F0A6E700A3235382E3037203233302E3733206D0A30202D37352E3236206C0A6F0A6E700A3235322E3938203135352E3437206D0A31302E31392030206C0A6F0A2F466F6E74312066696E64666F6E7420313120730A35342E3334203235312E393720286129202E35203020740A3137362E3538203235312E393720286129202E35203020740A39352E3038203235312E393720286129202E35203020740A3133352E3833203235312E393720286129202E35203020740A3231372E3333203235312E393720286129202E35203020740A3235382E3037203235312E393720286129202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E74203920730A302E3330323020302E3330323020302E3330323020737267620A32342E39362033362E3432202832292031203020740A32342E39362039372E3139202834292031203020740A32342E3936203135372E3936202836292031203020740A32342E3936203231382E3734202838292031203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E3230303020302E3230303020302E3230303020737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A32372E31352033392E3636206D0A322E37342030206C0A6F0A6E700A32372E3135203130302E3433206D0A322E37342030206C0A6F0A6E700A32372E3135203136312E3230206D0A322E37342030206C0A6F0A6E700A32372E3135203232312E3937206D0A322E37342030206C0A6F0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E3230303020302E3230303020302E3230303020737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A35342E33342032382E3631206D0A3020322E3734206C0A6F0A6E700A39352E30382032382E3631206D0A3020322E3734206C0A6F0A6E700A3133352E38332032382E3631206D0A3020322E3734206C0A6F0A6E700A3137362E35382032382E3631206D0A3020322E3734206C0A6F0A6E700A3231372E33332032382E3631206D0A3020322E3734206C0A6F0A6E700A3235382E30372032382E3631206D0A3020322E3734206C0A6F0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E74203920730A302E3330323020302E3330323020302E3330323020737267620A35342E33342031392E393520283129202E35203020740A39352E30382031392E393520283229202E35203020740A3133352E38332031392E393520283329202E35203020740A3137362E35382031392E393520283429202E35203020740A3231372E33332031392E393520283529202E35203020740A3235382E30372031392E393520283629202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313120730A302030203020737267620A3133312E313420372E36372028542920302074610A2D312E3332302028726561746D656E74292074622067720A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313120730A302030203020737267620A31352E3537203134382E393820284D65616E29202E3520393020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313320730A302030203020737267620A3135362E3230203237332E313920286C6D29202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A65700A2525547261696C65720A252550616765733A20310A2525454F460A0A0A20>|ps>|0.8par|||>
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Classes and Generic Functions>

    Each of the functions invoked inthe preceding examples are simply the
    <with|font-series|bold|generic> names of a larger family of related
    functions. Every R object has an associated type or class, and when a
    generic function is invoked with an R object as a parameter, the R
    interpreter will dispatch the appropriate specific instance of a generic
    function.

    For example, the result of an lm evaluation is an instance of the lm
    class:

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        class(Table5.7.lm)

        mode(Table5.7.lm)
      <|unfolded-io>
        class(Table5.7.lm)

        [1] "lm"

        \<gtr\> mode(Table5.7.lm)

        [1] "list"
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary
      <|unfolded-io>
        summary

        function (object, ...)\ 

        UseMethod("summary")

        \<less\>bytecode: 0x7f7fea4e5110\<gtr\>

        \<less\>environment: namespace:base\<gtr\>
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary.lm
      <|unfolded-io>
        summary.lm

        function (object, correlation = FALSE, symbolic.cor = FALSE,\ 

        \ \ \ \ ...)\ 

        {

        \ \ \ \ z \<less\>- object

        \ \ \ \ p \<less\>- z$rank

        \ \ \ \ rdf \<less\>- z$df.residual

        \ \ \ \ if (p == 0) {

        \ \ \ \ \ \ \ \ r \<less\>- z$residuals

        \ \ \ \ \ \ \ \ n \<less\>- length(r)

        \ \ \ \ \ \ \ \ w \<less\>- z$weights

        \ \ \ \ \ \ \ \ if (is.null(w)) {

        \ \ \ \ \ \ \ \ \ \ \ \ rss \<less\>- sum(r^2)

        \ \ \ \ \ \ \ \ }

        \ \ \ \ \ \ \ \ else {

        \ \ \ \ \ \ \ \ \ \ \ \ rss \<less\>- sum(w * r^2)

        \ \ \ \ \ \ \ \ \ \ \ \ r \<less\>- sqrt(w) * r

        \ \ \ \ \ \ \ \ }

        \ \ \ \ \ \ \ \ resvar \<less\>- rss/rdf

        \ \ \ \ \ \ \ \ ans \<less\>- z[c("call", "terms", if
        (!is.null(z$weights)) "weights")]

        \ \ \ \ \ \ \ \ class(ans) \<less\>- "summary.lm"

        \ \ \ \ \ \ \ \ ans$aliased \<less\>- is.na(coef(object))

        \ \ \ \ \ \ \ \ ans$residuals \<less\>- r

        \ \ \ \ \ \ \ \ ans$df \<less\>- c(0L, n, length(ans$aliased))

        \ \ \ \ \ \ \ \ ans$coefficients \<less\>- matrix(NA, 0L, 4L)

        \ \ \ \ \ \ \ \ dimnames(ans$coefficients) \<less\>- list(NULL,
        c("Estimate",\ 

        \ \ \ \ \ \ \ \ \ \ \ \ "Std. Error", "t value", "Pr(\<gtr\>\|t\|)"))

        \ \ \ \ \ \ \ \ ans$sigma \<less\>- sqrt(resvar)

        \ \ \ \ \ \ \ \ ans$r.squared \<less\>- ans$adj.r.squared \<less\>- 0

        \ \ \ \ \ \ \ \ return(ans)

        \ \ \ \ }

        \ \ \ \ if (is.null(z$terms))\ 

        \ \ \ \ \ \ \ \ stop("invalid 'lm' object: \ no 'terms' component")

        \ \ \ \ if (!inherits(object, "lm"))\ 

        \ \ \ \ \ \ \ \ warning("calling summary.lm(\<fake-lm-object\>) ...")

        \ \ \ \ Qr \<less\>- qr.lm(object)

        \ \ \ \ n \<less\>- NROW(Qr$qr)

        \ \ \ \ if (is.na(z$df.residual) \|\| n - p != z$df.residual)\ 

        \ \ \ \ \ \ \ \ warning("residual degrees of freedom in object
        suggest this is not an \\"lm\\" fit")

        \ \ \ \ r \<less\>- z$residuals

        \ \ \ \ f \<less\>- z$fitted.values

        \ \ \ \ w \<less\>- z$weights

        \ \ \ \ if (is.null(w)) {

        \ \ \ \ \ \ \ \ mss \<less\>- if (attr(z$terms, "intercept"))\ 

        \ \ \ \ \ \ \ \ \ \ \ \ sum((f - mean(f))^2)

        \ \ \ \ \ \ \ \ else sum(f^2)

        \ \ \ \ \ \ \ \ rss \<less\>- sum(r^2)

        \ \ \ \ }

        \ \ \ \ else {

        \ \ \ \ \ \ \ \ mss \<less\>- if (attr(z$terms, "intercept")) {

        \ \ \ \ \ \ \ \ \ \ \ \ m \<less\>- sum(w * f/sum(w))

        \ \ \ \ \ \ \ \ \ \ \ \ sum(w * (f - m)^2)

        \ \ \ \ \ \ \ \ }

        \ \ \ \ \ \ \ \ else sum(w * f^2)

        \ \ \ \ \ \ \ \ rss \<less\>- sum(w * r^2)

        \ \ \ \ \ \ \ \ r \<less\>- sqrt(w) * r

        \ \ \ \ }

        \ \ \ \ resvar \<less\>- rss/rdf

        \ \ \ \ if (is.finite(resvar) && resvar \<less\> (mean(f)^2 + var(f))
        *\ 

        \ \ \ \ \ \ \ \ 1e-30)\ 

        \ \ \ \ \ \ \ \ warning("essentially perfect fit: summary may be
        unreliable")

        \ \ \ \ p1 \<less\>- 1L:p

        \ \ \ \ R \<less\>- chol2inv(Qr$qr[p1, p1, drop = FALSE])

        \ \ \ \ se \<less\>- sqrt(diag(R) * resvar)

        \ \ \ \ est \<less\>- z$coefficients[Qr$pivot[p1]]

        \ \ \ \ tval \<less\>- est/se

        \ \ \ \ ans \<less\>- z[c("call", "terms", if (!is.null(z$weights))
        "weights")]

        \ \ \ \ ans$residuals \<less\>- r

        \ \ \ \ ans$coefficients \<less\>- cbind(est, se, tval, 2 *
        pt(abs(tval),\ 

        \ \ \ \ \ \ \ \ rdf, lower.tail = FALSE))

        \ \ \ \ dimnames(ans$coefficients) \<less\>-
        list(names(z$coefficients)[Qr$pivot[p1]],\ 

        \ \ \ \ \ \ \ \ c("Estimate", "Std. Error", "t value",
        "Pr(\<gtr\>\|t\|)"))

        \ \ \ \ ans$aliased \<less\>- is.na(coef(object))

        \ \ \ \ ans$sigma \<less\>- sqrt(resvar)

        \ \ \ \ ans$df \<less\>- c(p, rdf, NCOL(Qr$qr))

        \ \ \ \ if (p != attr(z$terms, "intercept")) {

        \ \ \ \ \ \ \ \ df.int \<less\>- if (attr(z$terms, "intercept"))\ 

        \ \ \ \ \ \ \ \ \ \ \ \ 1L

        \ \ \ \ \ \ \ \ else 0L

        \ \ \ \ \ \ \ \ ans$r.squared \<less\>- mss/(mss + rss)

        \ \ \ \ \ \ \ \ ans$adj.r.squared \<less\>- 1 - (1 - ans$r.squared) *
        ((n -\ 

        \ \ \ \ \ \ \ \ \ \ \ \ df.int)/rdf)

        \ \ \ \ \ \ \ \ ans$fstatistic \<less\>- c(value = (mss/(p -
        df.int))/resvar,\ 

        \ \ \ \ \ \ \ \ \ \ \ \ numdf = p - df.int, dendf = rdf)

        \ \ \ \ }

        \ \ \ \ else ans$r.squared \<less\>- ans$adj.r.squared \<less\>- 0

        \ \ \ \ ans$cov.unscaled \<less\>- R

        \ \ \ \ dimnames(ans$cov.unscaled) \<less\>-
        dimnames(ans$coefficients)[c(1,\ 

        \ \ \ \ \ \ \ \ 1)]

        \ \ \ \ if (correlation) {

        \ \ \ \ \ \ \ \ ans$correlation \<less\>- (R * resvar)/outer(se, se)

        \ \ \ \ \ \ \ \ dimnames(ans$correlation) \<less\>-
        dimnames(ans$cov.unscaled)

        \ \ \ \ \ \ \ \ ans$symbolic.cor \<less\>- symbolic.cor

        \ \ \ \ }

        \ \ \ \ if (!is.null(z$na.action))\ 

        \ \ \ \ \ \ \ \ ans$na.action \<less\>- z$na.action

        \ \ \ \ class(ans) \<less\>- "summary.lm"

        \ \ \ \ ans

        }

        \<less\>bytecode: 0x7f7fe9884200\<gtr\>

        \<less\>environment: namespace:stats\<gtr\>
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    Note that summary.lm both overrides (by extending to the lm class) and
    overloads (by adding additional parameters) the generic summary function.

    When a workflow is based on generic functions, new packages can be easily
    inserted into the workflow when package authors provide
    appropriaextensions to generic functions.
  </hidden>|<\hidden>
    <tit|Generic Functions>

    Some generic functions have default implementations that work for any
    type of R object.

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        print(anova(Table5.7.lm))
      <|unfolded-io>
        print(anova(Table5.7.lm))

        Analysis of Variance Table

        \;

        Response: obs

        \ \ \ \ \ \ \ \ \ \ Df Sum Sq Mean Sq F value \ \ Pr(\<gtr\>F) \ \ \ 

        trt \ \ \ \ \ \ \ 6 659.37 109.895 83.5934 1.26e-09 ***

        rep \ \ \ \ \ \ \ 3 \ 17.57 \ \ 5.858 \ 4.4561 \ 0.02316 * \ 

        Residuals 13 \ 17.09 \ \ 1.315 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(anova(Table5.7.lm))
      <|unfolded-io>
        summary(anova(Table5.7.lm))

        \ \ \ \ \ \ \ Df \ \ \ \ \ \ \ \ \ \ \ \ Sum Sq
        \ \ \ \ \ \ \ \ \ Mean Sq \ \ \ \ \ \ \ \ \ \ F value \ \ \ \ \ 

        \ Min. \ \ : 3.000 \ \ Min. \ \ : 17.09 \ \ Min. \ \ : \ 1.315
        \ \ Min. \ \ : 4.456 \ 

        \ 1st Qu.: 4.500 \ \ 1st Qu.: 17.33 \ \ 1st Qu.: \ 3.586 \ \ 1st
        Qu.:24.240 \ 

        \ Median : 6.000 \ \ Median : 17.57 \ \ Median : \ 5.858 \ \ Median
        :44.025 \ 

        \ Mean \ \ : 7.333 \ \ Mean \ \ :231.35 \ \ Mean \ \ : 39.023
        \ \ Mean \ \ :44.025 \ 

        \ 3rd Qu.: 9.500 \ \ 3rd Qu.:338.47 \ \ 3rd Qu.: 57.877 \ \ 3rd
        Qu.:63.809 \ 

        \ Max. \ \ :13.000 \ \ Max. \ \ :659.37 \ \ Max. \ \ :109.895
        \ \ Max. \ \ :83.593 \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ NA's
        \ \ :1 \ \ \ \ \ \ 

        \ \ \ \ \ Pr(\<gtr\>F) \ \ \ \ \ \ \ 

        \ Min. \ \ :0.000000 \ 

        \ 1st Qu.:0.005791 \ 

        \ Median :0.011582 \ 

        \ Mean \ \ :0.011582 \ 

        \ 3rd Qu.:0.017372 \ 

        \ Max. \ \ :0.023163 \ 

        \ NA's \ \ :1 \ \ \ \ \ \ \ \ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        class(anova(Table5.7.lm))
      <|unfolded-io>
        class(anova(Table5.7.lm))

        [1] "anova" \ \ \ \ \ "data.frame"
      </unfolded-io>

      <\textput>
        Some generic functions do not.
      </textput>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        VarCorr(Table5.7.lm)
      <|unfolded-io>
        VarCorr(Table5.7.lm)

        Error: could not find function "VarCorr"
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        \ 
      <|unfolded-io>
        \ 
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Automation>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        automate.analysis \<less\>- function(model) {

        \ \ \ require(lsmeans)

        \ \ \ require(multcomp)

        \ \ \ require(ggplot2)

        \ \ \ print(paste("Analyzing model of class",class(model)))

        \ \ \ print(summary(model))

        \ \ \ print(anova(model))

        \ \ \ print("Variance/Covariance")

        \ \ \ print(vcov(model))

        \ \ \ print("Hypothesis Testing")

        \ \ \ print(cld(glht(model,linfct=mcp(trt="Tukey")),decreasing=TRUE))

        \ \ \ print(lsmeans(model,cld ~ trt))

        \ \ \ return(plot.lsmeans(model,title=class(model)))

        }
      <|unfolded-io>
        automate.analysis \<less\>- function(model) {

        + \ \ \ require(lsmeans)

        + \ \ \ require(multcomp)

        + \ \ \ require(ggplot2)

        + \ \ \ print(paste("Analyzing model of class",class(model)))

        + \ \ \ print(summary(model))

        + \ \ \ print(anova(model))

        + \ \ \ print("Variance/Covariance")

        + \ \ \ print(vcov(model))

        + \ \ \ print("Hypothesis Testing")

        + \ \ \ print(cld(glht(model,linfct=mcp(trt="Tukey")),decreasing=TRUE))

        + \ \ \ print(lsmeans(model,cld ~ trt))

        + \ \ \ return(plot.lsmeans(model,title=class(model)))

        + }
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        automate.analysis(Table5.7.lm);v()
      <|unfolded-io>
        automate.analysis(Table5.7.lm);v()

        [1] "Analyzing model of class lm"

        \;

        Call:

        lm(formula = obs ~ 0 + trt + rep, data = Table5.7)

        \;

        Residuals:

        \ \ \ \ \ Min \ \ \ \ \ \ 1Q \ \ Median \ \ \ \ \ \ 3Q \ \ \ \ \ Max\ 

        -1.57367 -0.79233 \ 0.02958 \ 0.76387 \ 1.56967\ 

        \;

        Coefficients:

        \ \ \ \ \ Estimate Std. Error t value Pr(\<gtr\>\|t\|) \ \ \ 

        trt1 \ \ 2.4960 \ \ \ \ 1.0255 \ \ 2.434 0.030112 * \ 

        trt2 \ \ 3.4855 \ \ \ \ 0.7252 \ \ 4.807 0.000343 ***

        trt3 \ \ 3.8930 \ \ \ \ 0.7252 \ \ 5.368 0.000128 ***

        trt4 \ \ 3.4530 \ \ \ \ 0.7252 \ \ 4.762 0.000372 ***

        trt5 \ \ 4.1480 \ \ \ \ 0.7252 \ \ 5.720 7.05e-05 ***

        trt6 \ \ 5.6305 \ \ \ \ 0.7252 \ \ 7.764 3.10e-06 ***

        rep2 \ \ 2.6100 \ \ \ \ 0.7252 \ \ 3.599 0.003237 **\ 

        rep3 \ \ 1.3807 \ \ \ \ 0.7099 \ \ 1.945 0.073742 . \ 

        rep4 \ \ 1.6873 \ \ \ \ 0.7099 \ \ 2.377 0.033502 * \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        \;

        Residual standard error: 1.147 on 13 degrees of freedom

        Multiple R-squared: \ 0.9754, \ \ \ Adjusted R-squared: \ 0.9583\ 

        F-statistic: 57.21 on 9 and 13 DF, \ p-value: 5.409e-09

        \;

        Analysis of Variance Table

        \;

        Response: obs

        \ \ \ \ \ \ \ \ \ \ Df Sum Sq Mean Sq F value \ \ Pr(\<gtr\>F) \ \ \ 

        trt \ \ \ \ \ \ \ 6 659.37 109.895 83.5934 1.26e-09 ***

        rep \ \ \ \ \ \ \ 3 \ 17.57 \ \ 5.858 \ 4.4561 \ 0.02316 * \ 

        Residuals 13 \ 17.09 \ \ 1.315 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        [1] "Variance/Covariance"

        \ \ \ \ \ \ \ \ \ \ \ trt1 \ \ \ \ \ \ trt2 \ \ \ \ \ \ trt3
        \ \ \ \ \ \ trt4 \ \ \ \ \ \ trt5 \ \ \ \ \ \ trt6

        trt1 \ 1.0517130 \ 0.2629283 \ 0.2629283 \ 0.2629283 \ 0.2629283
        \ 0.2629283

        trt2 \ 0.2629283 \ 0.5258565 \ 0.1971962 \ 0.1971962 \ 0.1971962
        \ 0.1971962

        trt3 \ 0.2629283 \ 0.1971962 \ 0.5258565 \ 0.1971962 \ 0.1971962
        \ 0.1971962

        trt4 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.5258565 \ 0.1971962
        \ 0.1971962

        trt5 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.1971962 \ 0.5258565
        \ 0.1971962

        trt6 \ 0.2629283 \ 0.1971962 \ 0.1971962 \ 0.1971962 \ 0.1971962
        \ 0.5258565

        rep2 -0.2629283 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        rep3 -0.3943924 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        rep4 -0.3943924 -0.2629283 -0.2629283 -0.2629283 -0.2629283
        -0.2629283

        \ \ \ \ \ \ \ \ \ \ \ rep2 \ \ \ \ \ \ rep3 \ \ \ \ \ \ rep4

        trt1 -0.2629283 -0.3943924 -0.3943924

        trt2 -0.2629283 -0.2629283 -0.2629283

        trt3 -0.2629283 -0.2629283 -0.2629283

        trt4 -0.2629283 -0.2629283 -0.2629283

        trt5 -0.2629283 -0.2629283 -0.2629283

        trt6 -0.2629283 -0.2629283 -0.2629283

        rep2 \ 0.5258565 \ 0.2629283 \ 0.2629283

        rep3 \ 0.2629283 \ 0.5039458 \ 0.2848389

        rep4 \ 0.2629283 \ 0.2848389 \ 0.5039458

        [1] "Hypothesis Testing"

        \ \ 1 \ \ 2 \ \ 3 \ \ 4 \ \ 5 \ \ 6\ 

        "a" "a" "a" "a" "a" "a"\ 

        \ trt lsmean \ \ \ \ \ \ \ SE df lower.CL upper.CL .group

        \ 1 \ \ 3.9155 0.8503251 13 2.078484 5.752516 \ 1 \ \ \ 

        \ 4 \ \ 4.8725 0.5732890 13 3.633984 6.111016 \ 1 \ \ \ 

        \ 2 \ \ 4.9050 0.5732890 13 3.666484 6.143516 \ 1 \ \ \ 

        \ 3 \ \ 5.3125 0.5732890 13 4.073984 6.551016 \ 1 \ \ \ 

        \ 5 \ \ 5.5675 0.5732890 13 4.328984 6.806016 \ 1 \ \ \ 

        \ 6 \ \ 7.0500 0.5732890 13 5.811484 8.288516 \ 1 \ \ \ 

        \;

        Results are averaged over the levels of: rep\ 

        Confidence level used: 0.95\ 

        P value adjustment: tukey method for comparing a family of 6
        estimates\ 

        significance level used: alpha = 0.05\ 

        <image|<tuple|<#252150532D41646F62652D332E3020455053462D332E300A2525446F63756D656E744E65656465645265736F75726365733A20666F6E742048656C7665746963610A25252B20666F6E742048656C7665746963612D426F6C640A25252B20666F6E742048656C7665746963612D4F626C697175650A25252B20666F6E742048656C7665746963612D426F6C644F626C697175650A25252B20666F6E742053796D626F6C0A25255469746C653A2052204772617068696373204F75747075740A252543726561746F723A205220536F6674776172650A252550616765733A20286174656E64290A2525426F756E64696E67426F783A2030203020323838203238380A2525456E64436F6D6D656E74730A2525426567696E50726F6C6F670A2F627020207B2067732073524742206773207D206465660A2520626567696E202E70732E70726F6C6F670A2F677320207B206773617665207D2062696E64206465660A2F677220207B2067726573746F7265207D2062696E64206465660A2F657020207B2073686F7770616765206772206772207D2062696E64206465660A2F6D2020207B206D6F7665746F207D2062696E64206465660A2F6C20207B20726C696E65746F207D2062696E64206465660A2F6E7020207B206E657770617468207D2062696E64206465660A2F637020207B20636C6F736570617468207D2062696E64206465660A2F662020207B2066696C6C207D2062696E64206465660A2F6F2020207B207374726F6B65207D2062696E64206465660A2F632020207B206E65777061746820302033363020617263207D2062696E64206465660A2F722020207B2034203220726F6C6C206D6F7665746F203120636F70792033202D3120726F6C6C20657863682030206578636820726C696E65746F203020726C696E65746F202D31206D756C2030206578636820726C696E65746F20636C6F736570617468207D2062696E64206465660A2F703120207B207374726F6B65207D2062696E64206465660A2F703220207B2067736176652062672066696C6C2067726573746F7265206E657770617468207D2062696E64206465660A2F703320207B2067736176652062672066696C6C2067726573746F7265207374726F6B65207D2062696E64206465660A2F703620207B20677361766520626720656F66696C6C2067726573746F7265206E657770617468207D2062696E64206465660A2F703720207B20677361766520626720656F66696C6C2067726573746F7265207374726F6B65207D2062696E64206465660A2F742020207B2035202D3220726F6C6C206D6F7665746F20677361766520726F746174650A202020202020203120696E64657820737472696E67776964746820706F700A202020202020206D756C206E6567203020726D6F7665746F2073686F772067726573746F7265207D2062696E64206465660A2F746120207B2034202D3220726F6C6C206D6F7665746F20677361766520726F746174652073686F77207D2062696E64206465660A2F746220207B2032202D3120726F6C6C203020726D6F7665746F2073686F77207D2062696E64206465660A2F636C20207B2067726573746F7265206773617665206E657770617468203320696E646578203320696E646578206D6F7665746F203120696E6465780A2020202020202034202D3120726F6C6C206C696E65746F202065786368203120696E646578206C696E65746F206C696E65746F0A20202020202020636C6F73657061746820636C6970206E657770617468207D2062696E64206465660A2F726762207B20736574726762636F6C6F72207D2062696E64206465660A2F732020207B207363616C65666F6E7420736574666F6E74207D2062696E64206465660A2520656E642020202E70732E70726F6C6F670A2F73524742207B205B202F43494542617365644142430A0A202020202020202020203C3C202F4465636F64654C4D4E0A2020202020202020202020202020205B207B2064757020302E3033393238206C650A2020202020202020202020202020202020202020202020207B31322E3932333231206469767D0A2020202020202020202020202020202020202020202020207B302E3035352061646420312E3035352064697620322E3420657870207D0A2020202020202020202020202020202020202020206966656C73650A20202020202020202020202020202020207D2062696E6420647570206475700A2020202020202020202020202020205D0A202020202020202020202020202F4D61747269784C4D4E205B302E34313234353720302E32313236373320302E3031393333340A20202020202020202020202020202020202020202020202020302E33353735373620302E37313531353220302E3131393139320A20202020202020202020202020202020202020202020202020302E31383034333720302E30373231373520302E3935303330315D0A202020202020202020202020202F5768697465506F696E74205B302E3935303520312E3020312E303839305D0A20202020202020202020203E3E0A2020202020202020205D20736574636F6C6F727370616365207D2062696E64206465660A2F73726762207B20736574636F6C6F72207D2062696E64206465660A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963610A2F48656C7665746963612066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7431206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D426F6C640A2F48656C7665746963612D426F6C642066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7432206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D4F626C697175650A2F48656C7665746963612D4F626C697175652066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7433206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742048656C7665746963612D426F6C644F626C697175650A2F48656C7665746963612D426F6C644F626C697175652066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A20202F456E636F64696E672049534F4C6174696E31456E636F64696E67206465660A202063757272656E74646963740A2020656E640A2F466F6E7434206578636820646566696E65666F6E7420706F700A2525496E636C7564655265736F757263653A20666F6E742053796D626F6C0A2F53796D626F6C2066696E64666F6E740A647570206C656E677468206469637420626567696E0A20207B3120696E646578202F464944206E65207B6465667D207B706F7020706F707D206966656C73657D20666F72616C6C0A202063757272656E74646963740A2020656E640A2F466F6E7435206578636820646566696E65666F6E7420706F700A2525456E6450726F6C6F670A2525506167653A203120310A62700A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F6267207B2031203120312073726762207D206465660A312031203120737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A31207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A302E303020302E3030203238382E3030203238382E303020722070330A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A32392E38392033312E3335203238322E3532203236362E363120636C0A2F6267207B20302E3932313620302E3932313620302E393231362073726762207D206465660A32392E38392033312E3335203235322E3633203233352E323620722070320A312031203120737267620A302E3533207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A32392E38392037302E3034206D0A3235322E36332030206C0A6F0A6E700A32392E3839203133302E3831206D0A3235322E36332030206C0A6F0A6E700A32392E3839203139312E3538206D0A3235322E36332030206C0A6F0A6E700A32392E3839203235322E3335206D0A3235322E36332030206C0A6F0A312E3037207365746C696E6577696474680A5B5D203020736574646173680A6E700A32392E38392033392E3636206D0A3235322E36332030206C0A6F0A6E700A32392E3839203130302E3433206D0A3235322E36332030206C0A6F0A6E700A32392E3839203136312E3230206D0A3235322E36332030206C0A6F0A6E700A32392E3839203232312E3937206D0A3235322E36332030206C0A6F0A6E700A35342E33342033312E3335206D0A30203233352E3236206C0A6F0A6E700A39352E30382033312E3335206D0A30203233352E3236206C0A6F0A6E700A3133352E38332033312E3335206D0A30203233352E3236206C0A6F0A6E700A3137362E35382033312E3335206D0A30203233352E3236206C0A6F0A6E700A3231372E33332033312E3335206D0A30203233352E3236206C0A6F0A6E700A3235382E30372033312E3335206D0A30203233352E3236206C0A6F0A2F6267207B20302E3630303020302E3630303020302E363030302073726762207D206465660A33362E3030202D32312E31312033362E3637203131382E393720722070320A2F6267207B20302E3930323020302E3632333520302073726762207D206465660A37362E3735202D32312E31312033362E3637203134392E303420722070320A2F6267207B20302E3333373320302E3730353920302E393133372073726762207D206465660A3131372E3439202D32312E31312033362E3637203136312E343220722070320A2F6267207B203020302E3631393620302E343531302073726762207D206465660A3135382E3234202D32312E31312033362E3637203134382E303520722070320A2F6267207B203020302E3434373120302E363938302073726762207D206465660A3139382E3939202D32312E31312033362E3637203136392E313720722070320A2F6267207B20302E3833353320302E3336383620302073726762207D206465660A3233392E3734202D32312E31312033362E3637203231342E323120722070320A302030203020737267620A312E3030207365746D697465726C696D69740A6E700A34392E3234203135332E3638206D0A31302E31392030206C0A6F0A6E700A35342E3334203135332E3638206D0A30202D3131312E3634206C0A6F0A6E700A34392E32342034322E3034206D0A31302E31392030206C0A6F0A6E700A38392E3939203136352E3536206D0A31302E31392030206C0A6F0A6E700A39352E3038203136352E3536206D0A30202D37352E3237206C0A6F0A6E700A38392E39392039302E3239206D0A31302E31392030206C0A6F0A6E700A3133302E3734203137372E3934206D0A31302E31382030206C0A6F0A6E700A3133352E3833203137372E3934206D0A30202D37352E3237206C0A6F0A6E700A3133302E3734203130322E3637206D0A31302E31382030206C0A6F0A6E700A3137312E3438203136342E3537206D0A31302E31392030206C0A6F0A6E700A3137362E3538203136342E3537206D0A30202D37352E3237206C0A6F0A6E700A3137312E34382038392E3330206D0A31302E31392030206C0A6F0A6E700A3231322E3233203138352E3639206D0A31302E31392030206C0A6F0A6E700A3231372E3333203138352E3639206D0A30202D37352E3237206C0A6F0A6E700A3231322E3233203131302E3432206D0A31302E31392030206C0A6F0A6E700A3235322E3938203233302E3733206D0A31302E31392030206C0A6F0A6E700A3235382E3037203233302E3733206D0A30202D37352E3236206C0A6F0A6E700A3235322E3938203135352E3437206D0A31302E31392030206C0A6F0A2F466F6E74312066696E64666F6E7420313120730A35342E3334203235312E393720286129202E35203020740A3137362E3538203235312E393720286129202E35203020740A39352E3038203235312E393720286129202E35203020740A3133352E3833203235312E393720286129202E35203020740A3231372E3333203235312E393720286129202E35203020740A3235382E3037203235312E393720286129202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E74203920730A302E3330323020302E3330323020302E3330323020737267620A32342E39362033362E3432202832292031203020740A32342E39362039372E3139202834292031203020740A32342E3936203135372E3936202836292031203020740A32342E3936203231382E3734202838292031203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E3230303020302E3230303020302E3230303020737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A32372E31352033392E3636206D0A322E37342030206C0A6F0A6E700A32372E3135203130302E3433206D0A322E37342030206C0A6F0A6E700A32372E3135203136312E3230206D0A322E37342030206C0A6F0A6E700A32372E3135203232312E3937206D0A322E37342030206C0A6F0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E3230303020302E3230303020302E3230303020737267620A312E3037207365746C696E6577696474680A5B5D203020736574646173680A30207365746C696E656361700A31207365746C696E656A6F696E0A31302E3030207365746D697465726C696D69740A6E700A35342E33342032382E3631206D0A3020322E3734206C0A6F0A6E700A39352E30382032382E3631206D0A3020322E3734206C0A6F0A6E700A3133352E38332032382E3631206D0A3020322E3734206C0A6F0A6E700A3137362E35382032382E3631206D0A3020322E3734206C0A6F0A6E700A3231372E33332032382E3631206D0A3020322E3734206C0A6F0A6E700A3235382E30372032382E3631206D0A3020322E3734206C0A6F0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E74203920730A302E3330323020302E3330323020302E3330323020737267620A35342E33342031392E393520283129202E35203020740A39352E30382031392E393520283229202E35203020740A3133352E38332031392E393520283329202E35203020740A3137362E35382031392E393520283429202E35203020740A3231372E33332031392E393520283529202E35203020740A3235382E30372031392E393520283629202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313120730A302030203020737267620A3133312E313420372E36372028542920302074610A2D312E3332302028726561746D656E74292074622067720A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313120730A302030203020737267620A31352E3537203134382E393820284D65616E29202E3520393020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A2F466F6E74312066696E64666F6E7420313320730A302030203020737267620A3135362E3230203237332E313920286C6D29202E35203020740A302E303020302E3030203238382E3030203238382E303020636C0A302E303020302E3030203238382E3030203238382E303020636C0A65700A2525547261696C65720A252550616765733A20310A2525454F460A0A0A20>|ps>|0.8par|||>
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\shown>
    <tit|Comparison - Generic Functions>

    <big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|plot>|<cell|summary>|<cell|anova(.)>|<cell|anova(.,.)>|<cell|update>>|<row|<cell|lm>|<cell|yes>|<cell|yes>|<cell|yes>|<cell|yes>|<cell|yes>>|<row|<cell|lme>|<cell|yes
    (a)>|<cell|yes>|<cell|yes>|<cell|yes (d)>|<cell|yes>>|<row|<cell|glmmPQL>|<cell|yes
    (a)>|<cell|yes>|<cell|no>|<cell|no>|<cell|yes>>|<row|<cell|lmer>|<cell|yes
    (b)>|<cell|yes>|<cell|yes>|<cell|yes (g)>|<cell|yes>>|<row|<cell|blmer>|<cell|yes
    (b)>|<cell|yes>|<cell|yes>|<cell|yes (g)>|<cell|yes>>|<row|<cell|glmmadmb
    (k)>|<cell|no>|<cell|yes (l)>|<cell|no (m)>|<cell|yes
    (n)>|<cell|yes>>|<row|<cell|glmmLasso>|<cell|no (p)>|<cell|yes
    (q)>|<cell|no>|<cell|no (s)>|<cell|no
    (r)>>|<row|<cell|lmm>|<cell|no>|<cell|yes
    (o)>|<cell|no>|<cell|no>|<cell|no>>|<row|<cell|MCMCglmm>|<cell|yes
    (h)>|<cell|yes>|<cell|no>|<cell|no>|<cell|no>>|<row|<cell|inla>|yes
    (i)|<cell|yes>|<cell|no>|<cell|no>|<cell|no>>|<row|<cell|brm>|<cell|yes
    (j)>|<cell|>|<cell|>|<cell|>|<cell|>>>>>|>

    <\enumerate-alpha>
      <item>Residual plot only, qqnorm is avaible for QQ plots

      <item>Residual plot only, qqnorm is not avaible

      <item>summary missing logLik, AIC, BIC values; logLik.glmmPQL returns
      NA.

      <item><verbatim|fitted objects with different fixed effects. REML
      comparisons are not meaningful>

      <item><verbatim|'anova' is not available for PQL fits>

      <item>no p-values for F tests

      <item><verbatim|refitting model(s) with ML (instead of REML)>

      <item>requires <verbatim|Hit \<Return\> to see next plot:>

      <item>opens several plot windows simultaneously

      <item>ggplot is used to provide very elegant graphs

      <item><verbatim|In eval(expr, envir, enclos) : sd.est not defined for
      this family.> \ 

      glmmadmb reports Error in svd(x, 0, 0) : a dimension is zero for a 0 +
      (1 \| rep) model.

      <item><verbatim|In .local(x, sigma, ...) :>

      \ \ <verbatim|'sigma' and 'rdig' arguments are present for
      compatibility only: ignored.>\ 

      AIC reported, but not BIC or logLik.

      <item><verbatim|Error in anova.glmmadmb(Table5.7.admb) : Two or more
      model fits required>

      <item>Analysis of Deviance Table, logLik only

      <item>summary.list

      <item>No smooth terms to plot!

      <item>No residual term reported, so Standard Error of fixed effect
      estimates is NA.

      <item>Error in formula.default(object) : invalid formula

      \;
    </enumerate-alpha>

    \;
  </shown>|<\hidden>
    <tit|Mixed Model Formulation>

    <big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|coef>|<cell|vcov>|<cell|glht>|<cell|lsmeans>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lm>|<cell|vector>|<cell|>|<cell|>|<cell|>>|<row|<cell|lme>|<cell|matrix>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmPQL>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lmer>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|blmer>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmadmb>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lmm>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmLasso>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|MCMCglmm>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|inla>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|brm>|<cell|>|<cell|>|<cell|>|<cell|>>>>>|>
  </hidden>|<\hidden>
    <tit|Overview of Packages for LMM Solutions>

    <big-table|<tabular|<tformat|<table|<row|<cell|Function>|<cell|Package>|<cell|Version>|<cell|Maintainer>>|<row|<cell|lme>|<cell|nlme>|<cell|>|<cell|>>|<row|<cell|glmmPQL>|<cell|MASS>|<cell|>|<cell|>>|<row|<cell|lmer>|<cell|lme4>|<cell|>|<cell|>>|<row|<cell|blmer>|<cell|blme>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmadmb
    (a)>|<cell|glmmADMB>|<cell|>|<cell|>>|<row|<cell|glmmLasso>|<cell|glmmLasso>|<cell|1.4.4
    2016-05-28>|<cell|Andreas Groll groll@mathematik.uni-muenchen.de>>|<row|<cell|lmm>|<cell|minque>|<cell|>|<cell|>>|<row|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|MCMCglmm>|<cell|MCMCglmm>|<cell|>|<cell|>>|<row|<cell|inla
    (b)>|<cell|INLA>|<cell|>|<cell|>>|<row|<cell|brm
    (c)>|<cell|brms>|<cell|>|<cell|>>>>>|>

    <\enumerate-alpha>
      <item>not on CRAN, install.packages("glmmADMB",
      repos=c("http://glmmadmb.r-forge.r-project.org/repos",
      getOption("repos")),type="source")

      <item>not on CRAN, install from. Source is also available at
      http://bitbucket.org/hrue/r-inla

      <item>uses external C++ compiler; may be difficult for some users.
    </enumerate-alpha>

    http://glmm.wikidot.com/pkg-comparison
  </hidden>|<\hidden>
    <tit|lme (anova)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        anova(Table5.7.lme)

        anova(Table5.7.red.lme,Table5.7.lme)
      <|unfolded-io>
        anova(Table5.7.lme)

        \ \ \ \ numDF denDF \ F-value p-value

        trt \ \ \ \ 6 \ \ \ 13 19.36485 \ \<less\>.0001

        \<gtr\> anova(Table5.7.red.lme,Table5.7.lme)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Model df \ \ \ \ \ AIC
        \ \ \ \ \ \ BIC \ \ \ logLik \ \ Test \ L.Ratio

        Table5.7.red.lme \ \ \ \ 1 \ 2 98.41724 100.59932 -47.20862
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        Table5.7.lme \ \ \ \ \ \ \ \ 2 \ 8 78.02787 \ 84.20858 -31.01393 1 vs
        2 32.38937

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ p-value

        Table5.7.red.lme \ \ \ \ \ \ \ 

        Table5.7.lme \ \ \ \ \ \<less\>.0001

        Warning message:

        In anova.lme(Table5.7.red.lme, Table5.7.lme) :

        \ \ fitted objects with different fixed effects. REML comparisons are
        not meaningful.
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|lme (variance)>

    <\session|r|default>
      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|lme (hypothesis)>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(glht(Table5.7.lm,linfct=mcp(trt="Dunnett")))\ 
      <|unfolded-io>
        \;
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(glht(Table5.7.lme,linfct=mcp(trt="Dunnett")))
      <|unfolded-io>
        \;
      </unfolded-io>

      \;
    </session>

    \;
  </hidden>|<\hidden>
    <tit|lme (variances)>

    <\session|r|default>
      <\folded-io>
        <with|color|red|\<gtr\> >
      <|folded-io>
        print(vtbl \<less\>- vcov(Table5.7.lme))
      <|folded-io>
        print(vtbl \<less\>- vcov(Table5.7.lme))

        \ \ \ \ \ \ \ \ \ \ trt1 \ \ \ \ \ trt2 \ \ \ \ \ trt3 \ \ \ \ \ trt4
        \ \ \ \ \ trt5 \ \ \ \ \ trt6

        trt1 0.9328210 0.2227121 0.2227121 0.2227121 0.2227121 0.2227121

        trt2 0.2227121 0.5523330 0.2227121 0.2227121 0.2227121 0.2227121

        trt3 0.2227121 0.2227121 0.5523330 0.2227121 0.2227121 0.2227121

        trt4 0.2227121 0.2227121 0.2227121 0.5523330 0.2227121 0.2227121

        trt5 0.2227121 0.2227121 0.2227121 0.2227121 0.5523330 0.2227121

        trt6 0.2227121 0.2227121 0.2227121 0.2227121 0.2227121 0.5523330
      </folded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        sqrt(vtbl[1,1]);sqrt(vtbl[2,2])
      <|unfolded-io>
        sqrt(vtbl[1,1]);sqrt(vtbl[2,2])

        [1] 0.9658266

        [1] 0.7431911
      </unfolded-io>

      <\textput>
        Corresponding errors from lsmeans(Table5.7.lme,cld ~ trt) are
        0.9658266 and 0.7431911
      </textput>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        sqrt(vtbl[1,1]+vtbl[2,2]-vtbl[1,2]-vtbl[2,1])
      <|unfolded-io>
        sqrt(vtbl[1,1]+vtbl[2,2]-vtbl[1,2]-vtbl[2,1])

        [1] 1.019671
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        sqrt(vtbl[3,3]+vtbl[2,2]-vtbl[3,2]-vtbl[2,3])
      <|unfolded-io>
        sqrt(vtbl[3,3]+vtbl[2,2]-vtbl[3,2]-vtbl[2,3])

        [1] 0.8119371
      </unfolded-io>

      <\textput>
        Corresponding errors from glht(Table5.7.lme,linfct=mcp(trt="Tukey"))
        are 1.0197 and 0.8119
      </textput>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|glmmPQL>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        library(MASS)

        Table5.7.glmmPQL \<less\>- glmmPQL(obs ~ 0+trt, random = ~ 1 \|
        rep,family=gaussian, data = Table5.7)

        class(Table5.7.glmmPQL)
      <|unfolded-io>
        library(MASS)

        \<gtr\> Table5.7.glmmPQL \<less\>- glmmPQL(obs ~ 0+trt, random = ~ 1
        \| rep,family=gaussian

        \<less\>QL(obs ~ 0+trt, random = ~ 1 \| rep,family=gaussian, data =
        Table5.7)

        iteration 1

        iteration 2

        \<gtr\> class(Table5.7.glmmPQL)

        [1] "glmmPQL" "lme" \ \ \ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        methods("vcov");methods("anova")
      <|unfolded-io>
        methods("vcov");methods("anova")

        \ [1] vcov.Arima* \ \ \ \ \ \ vcov.cch* \ \ \ \ \ \ \ \ vcov.coxph*
        \ \ \ \ \ \ vcov.fitdistr* \ \ 

        \ [5] vcov.glht* \ \ \ \ \ \ \ vcov.glht.list* \ \ vcov.glm*
        \ \ \ \ \ \ \ \ vcov.gls* \ \ \ \ \ \ \ 

        \ [9] vcov.lm* \ \ \ \ \ \ \ \ \ vcov.lme* \ \ \ \ \ \ \ \ vcov.mlm*
        \ \ \ \ \ \ \ \ vcov.mmm* \ \ \ \ \ \ \ 

        [13] vcov.negbin* \ \ \ \ \ vcov.nls* \ \ \ \ \ \ \ \ vcov.parm*
        \ \ \ \ \ \ \ vcov.polr* \ \ \ \ \ \ 

        [17] vcov.ref.grid* \ \ \ vcov.rlm* \ \ \ \ \ \ \ \ vcov.summary.glm*
        vcov.summary.lm*\ 

        [21] vcov.survreg* \ \ \ 

        see '?methods' for accessing help and source code

        \ [1] anova.coxph* \ \ \ \ \ \ anova.coxphlist* \ \ anova.glm*
        \ \ \ \ \ \ \ 

        \ [4] anova.glmlist* \ \ \ \ anova.glmmPQL* \ \ \ \ anova.gls*
        \ \ \ \ \ \ \ 

        \ [7] anova.lm* \ \ \ \ \ \ \ \ \ anova.lme
        \ \ \ \ \ \ \ \ \ anova.lmlist* \ \ \ \ 

        [10] anova.loess* \ \ \ \ \ \ anova.loglm* \ \ \ \ \ \ anova.mlm*
        \ \ \ \ \ \ \ 

        [13] anova.negbin* \ \ \ \ \ anova.nls* \ \ \ \ \ \ \ \ anova.polr*
        \ \ \ \ \ \ 

        [16] anova.survreg* \ \ \ \ anova.survreglist*

        see '?methods' for accessing help and source code
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        anova(Table5.7.glmmPQL)
      <|unfolded-io>
        anova(Table5.7.glmmPQL)

        Error in anova.glmmPQL(Table5.7.glmmPQL) :\ 

        \ \ 'anova' is not available for PQL fits
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        vcov(Table5.7.glmmPQL)
      <|unfolded-io>
        vcov(Table5.7.glmmPQL)

        \ \ \ \ \ \ \ \ \ \ trt1 \ \ \ \ \ trt2 \ \ \ \ \ trt3 \ \ \ \ \ trt4
        \ \ \ \ \ trt5 \ \ \ \ \ trt6

        trt1 0.6813440 0.1675289 0.1675289 0.1675289 0.1675289 0.1675289

        trt2 0.1675289 0.4058812 0.1675289 0.1675289 0.1675289 0.1675289

        trt3 0.1675289 0.1675289 0.4058812 0.1675289 0.1675289 0.1675289

        trt4 0.1675289 0.1675289 0.1675289 0.4058812 0.1675289 0.1675289

        trt5 0.1675289 0.1675289 0.1675289 0.1675289 0.4058812 0.1675289

        trt6 0.1675289 0.1675289 0.1675289 0.1675289 0.1675289 0.4058812
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    Table5.7.red.glmmPQL\<less\>- update(Table5.7.glmmPQL, . ~ . -trt)

    #summary(Table5.7.glmmPQL)

    #anova(Table5.7.glmmPQL)

    #summary(aov(Table5.7.glmmPQL))

    VarCorr(Table5.7.glmmPQL)

    fixef(Table5.7.glmmPQL)

    summary(glht(Table5.7.glmmPQL,linfct=mcp(trt="Dunnett")))

    cld(glht(Table5.7.glmmPQL,linfct=mcp(trt="Tukey")),decreasing=TRUE)

    print(Table5.7.glmmPQL.tbl \<less\>- lsmeans(Table5.7.glmmPQL,cld ~ trt))
  </hidden>|<\hidden>
    <tit|glmmadmb>

    glmmADMB is not available fron CRAN so must be installed via

    <verbatim|install.packages("glmmADMB",
    repos=c("http://glmmadmb.r-forge.r-project.org/repos",
    getOption("repos")),type="source")>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        library(glmmADMB)

        Table5.7.admb \<less\>- glmmadmb(obs ~ 0+trt, random = ~ 1 \| rep,
        family = "gaussian", data = Table5.7)
      <|unfolded-io>
        library(glmmADMB)

        \;

        Attaching package: 'glmmADMB'

        \;

        The following object is masked from 'package:MASS':

        \;

        \ \ \ \ stepAIC

        \;

        The following object is masked from 'package:stats':

        \;

        \ \ \ \ step

        \;

        \<gtr\> Table5.7.admb \<less\>- glmmadmb(obs ~ 0+trt, random = ~ 1 \|
        rep, family = "gaussi

        \<less\>(obs ~ 0+trt, random = ~ 1 \| rep, family = "gaussian", data
        = Table5.7)

        Warning message:

        In eval(expr, envir, enclos) : sd.est not defined for this family
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7.red.admb \<less\>- update(Table5.7.admb, . ~ . - trt)

        \;
      <|unfolded-io>
        Table5.7.red.admb \<less\>- update(Table5.7.admb, . ~ . - trt)

        Error in svd(x, 0, 0) : a dimension is zero

        \<gtr\>\ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(Table5.7.admb)
      <|unfolded-io>
        summary(Table5.7.admb)

        \;

        Call:

        glmmadmb(formula = obs ~ 0 + trt, data = Table5.7, family =
        "gaussian",\ 

        \ \ \ \ random = ~1 \| rep)

        \;

        AIC: 83.7\ 

        \;

        Coefficients:

        \ \ \ \ \ Estimate Std. Error z value Pr(\<gtr\>\|z\|) \ \ \ 

        trt1 \ \ \ 3.941 \ \ \ \ \ 0.826 \ \ \ 4.77 \ 1.8e-06 ***

        trt2 \ \ \ 4.905 \ \ \ \ \ 0.637 \ \ \ 7.70 \ 1.4e-14 ***

        trt3 \ \ \ 5.313 \ \ \ \ \ 0.637 \ \ \ 8.34 \ \<less\> 2e-16 ***

        trt4 \ \ \ 4.873 \ \ \ \ \ 0.637 \ \ \ 7.65 \ 2.0e-14 ***

        trt5 \ \ \ 5.568 \ \ \ \ \ 0.637 \ \ \ 8.74 \ \<less\> 2e-16 ***

        trt6 \ \ \ 7.050 \ \ \ \ \ 0.637 \ \ 11.07 \ \<less\> 2e-16 ***

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        \;

        Number of observations: total=22, rep=4\ 

        Random effect variance(s):

        Group=rep

        \ \ \ \ \ \ \ \ \ \ \ \ Variance StdDev

        (Intercept) \ \ 0.6701 0.8186

        \;

        Residual variance: 0.97642 (std. err.: 0.16343)

        \;

        Log-likelihood: -33.851\ 

        Warning message:

        In .local(x, sigma, ...) :

        \ \ 'sigma' and 'rdig' arguments are present for compatibility only:
        ignored
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|glmmadmb anova>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        anova(Table5.7.admb)
      <|unfolded-io>
        anova(Table5.7.admb)

        Error in anova.glmmadmb(Table5.7.admb) : Two or more model fits
        required.
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(aov(Table5.7.admb))
      <|unfolded-io>
        summary(aov(Table5.7.admb))

        \ \ \ \ \ \ \ \ \ \ Df Sum Sq Mean Sq F value \ \ Pr(\<gtr\>F) \ \ \ 

        trt \ \ \ \ \ \ \ 6 \ 659.4 \ 109.90 \ \ 50.72 1.59e-09 ***

        Residuals 16 \ \ 34.7 \ \ \ 2.17 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        anova(glmmadmb(obs ~ 1, random = ~ 1 \| rep, family = "gaussian",
        data = Table5.7),

        \ \ \ \ \ \ glmmadmb(obs ~ trt, random = ~ 1 \| rep, family =
        "gaussian", data = Table5.7))
      <|unfolded-io>
        anova(glmmadmb(obs ~ 1, random = ~ 1 \| rep, family = "gaussian",
        data = Tab

        \<less\>andom = ~ 1 \| rep, family = "gaussian", data = Table5.7),

        + \ \ \ \ \ \ glmmadmb(obs ~ trt, random = ~ 1 \| rep, family =
        "gaussian", data = T

        \<less\> random = ~ 1 \| rep, family = "gaussian", data = Table5.7))

        Analysis of Deviance Table

        \;

        Model 1: obs ~ 1

        Model 2: obs ~ trt

        \ \ NoPar \ LogLik Df Deviance Pr(\<gtr\>Chi) \ 

        1 \ \ \ \ 3 -40.032 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        2 \ \ \ \ 8 -33.851 \ 5 \ \ 12.361 \ 0.03016 *

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        Warning messages:

        1: In eval(expr, envir, enclos) : sd.est not defined for this family

        2: In eval(expr, envir, enclos) : sd.est not defined for this family
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|glmmLasso>

    \;

    <\session|r|default>
      <\folded-io>
        <with|color|red|\<gtr\> >
      <|folded-io>
        library(glmmLasso)

        Table5.7.glmmLasso \<less\>- glmmLasso(fix = obs ~ 0 + trt, rnd =
        list(rep = ~1), lambda = 200, data = Table5.7)
      <|folded-io>
        library(glmmLasso)

        \<gtr\> Table5.7.glmmLasso \<less\>- glmmLasso(fix = obs ~ 0 + trt,
        rnd = list(rep = ~1),\ 

        \<less\>mLasso(fix = obs ~ 0 + trt, rnd = list(rep = ~1), lambda =
        200, data = Table

        \<less\>, rnd = list(rep = ~1), lambda = 200, data = Table5.7)

        Error in est.glmmLasso.RE(fix = fix, rnd = rnd, data = data, lambda =
        lambda, \ :\ 

        \ \ Need intercept term when using center = TRUE
      </folded-io>

      <\folded-io>
        <with|color|red|\<gtr\> >
      <|folded-io>
        glmmLasso(fix = obs ~ 0 + trt, rnd = list(rep = ~1), lambda = 200,
        control=list(center=FALSE), data = Table5.7)
      <|folded-io>
        glmmLasso(fix = obs ~ 0 + trt, rnd = list(rep = ~1), lambda = 200,
        control=

        \<less\> trt, rnd = list(rep = ~1), lambda = 200,
        control=list(center=FALSE), data =

        \<less\>, lambda = 200, control=list(center=FALSE), data = Table5.7)

        Call:

        glmmLasso(fix = obs ~ 0 + trt, rnd = list(rep = ~1), data = Table5.7,\ 

        \ \ \ \ lambda = 200, control = list(center = FALSE))

        \;

        Fixed Effects:

        \;

        Coefficients:

        trt1 trt2 trt3 trt4 trt5 trt6\ 

        \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0 \ \ \ 0\ 

        \;

        Random Effects:

        \;

        StdDev:

        \ \ \ \ \ \ \ \ \ rep

        rep 5.499208
      </folded-io>

      <\folded-io>
        <with|color|red|\<gtr\> >
      <|folded-io>
        Table5.7.glmmLasso \<less\>- glmmLasso(fix = obs ~ trt, rnd =
        list(rep = ~1), lambda = 200, data = Table5.7,final.re=TRUE)
      <|folded-io>
        Table5.7.glmmLasso \<less\>- glmmLasso(fix = obs ~ trt, rnd =
        list(rep = ~1), lamb

        \<less\>mLasso(fix = obs ~ trt, rnd = list(rep = ~1), lambda = 200,
        data = Table5.7,

        \<less\>d = list(rep = ~1), lambda = 200, data =
        Table5.7,final.re=TRUE)
      </folded-io>

      <\folded-io>
        <with|color|red|\<gtr\> >
      <|folded-io>
        Table5.7.red.glmmLasso \<less\>- update(Table5.7.glmmLasso, obs ~ 1)
      <|folded-io>
        Table5.7.red.glmmLasso \<less\>- update(Table5.7.glmmLasso, obs ~ 1)

        Error in formula.default(object) : invalid formula
      </folded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|MCMCglmm>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Table5.7.red.mcmc \<less\>- MCMCglmm(fixed=obs ~ 1, random = ~ rep,
        data=Table5.7, verbose=FALSE)
      <|unfolded-io>
        Table5.7.red.mcmc \<less\>- MCMCglmm(fixed=obs ~ 1, random = ~ rep,
        data=Table5.7,

        \<less\>glmm(fixed=obs ~ 1, random = ~ rep, data=Table5.7,
        verbose=FALSE)
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        anova(Table5.7.mcmc,Table5.7.red.mcmc)
      <|unfolded-io>
        anova(Table5.7.mcmc,Table5.7.red.mcmc)

        Error in UseMethod("anova") :\ 

        \ \ no applicable method for 'anova' applied to an object of class
        "MCMCglmm"
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(Table5.7.red.mcmc)$DIC

        summary(Table5.7.mcmc)$DIC
      <|unfolded-io>
        summary(Table5.7.red.mcmc)$DIC

        [1] 85.15184

        \<gtr\> summary(Table5.7.mcmc)$DIC

        [1] 87.4415
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|inla>

    Also not on CRAN, install via

    <verbatim|install.packages("INLA", repos="http://www.math.ntnu.no/inla/R/stable")>

    <\session|r|default>
      <\folded-io>
        <with|color|red|\<gtr\> >
      <|folded-io>
        library(INLA)

        Table5.7.inla \<less\>- inla(obs ~ 0 + trt + f(rep, model="iid"),
        data=Table5.7)
      <|folded-io>
        library(INLA)

        \<gtr\> Table5.7.inla \<less\>- inla(obs ~ 0 + trt + f(rep,
        model="iid"), data=Table5.7)
      </folded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(Table5.7.inla)
      <|unfolded-io>
        summary(Table5.7.inla)

        \;

        Call:

        "inla(formula = obs ~ 0 + trt + f(rep, model = \\"iid\\"), data =
        Table5.7)"

        \;

        Time used:

        \ Pre-processing \ \ \ Running inla Post-processing
        \ \ \ \ \ \ \ \ \ \ Total\ 

        \ \ \ \ \ \ \ \ \ 2.9067 \ \ \ \ \ \ \ \ \ 0.4182
        \ \ \ \ \ \ \ \ \ 0.0832 \ \ \ \ \ \ \ \ \ 3.4081\ 

        \;

        Fixed effects:

        \ \ \ \ \ \ \ mean \ \ \ \ sd 0.025quant 0.5quant 0.975quant \ \ mode
        kld

        trt1 4.0256 1.0372 \ \ \ \ 1.9668 \ \ 4.0258 \ \ \ \ 6.0798 4.0262
        \ \ 0

        trt2 4.9024 0.7336 \ \ \ \ 3.4462 \ \ 4.9025 \ \ \ \ 6.3554 4.9028
        \ \ 0

        trt3 5.3096 0.7336 \ \ \ \ 3.8534 \ \ 5.3098 \ \ \ \ 6.7626 5.3101
        \ \ 0

        trt4 4.8699 0.7336 \ \ \ \ 3.4137 \ \ 4.8700 \ \ \ \ 6.3229 4.8703
        \ \ 0

        trt5 5.5645 0.7336 \ \ \ \ 4.1082 \ \ 5.5646 \ \ \ \ 7.0175 5.5650
        \ \ 0

        trt6 7.0462 0.7336 \ \ \ \ 5.5898 \ \ 7.0464 \ \ \ \ 8.4990 7.0468
        \ \ 0

        \;

        Random effects:

        Name \ \ \ \ \ Model

        \ rep \ \ IID model\ 

        \;

        Model hyperparameters:

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ mean
        \ \ \ \ \ \ \ sd 0.025quant

        Precision for the Gaussian observations 5.172e-01 1.725e-01
        \ \ \ \ \ 0.247

        Precision for rep \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.856e+04
        1.835e+04 \ \ 1263.814

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.5quant
        0.975quant \ \ \ \ \ mode

        Precision for the Gaussian observations 4.957e-01 \ 9.155e-01
        \ \ \ 0.4545

        Precision for rep \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.316e+04
        \ 6.692e+04 3431.5788

        \;

        Expected number of effective parameters(std dev): 5.998(0.005)

        Number of equivalent replicates : 3.668\ 

        \;

        Marginal log-Likelihood: \ -69.90\ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        anova(Table5.7.inla)
      <|unfolded-io>
        anova(Table5.7.inla)

        Error in UseMethod("anova") :\ 

        \ \ no applicable method for 'anova' applied to an object of class
        "inla"
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        vcov(Table5.7.inla)
      <|unfolded-io>
        vcov(Table5.7.inla)

        Error in UseMethod("vcov") :\ 

        \ \ no applicable method for 'vcov' applied to an object of class
        "inla"
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;

    \;
  </hidden>|<\hidden>
    <tit|brms>

    Note that this needs stan to be installed, apparently not just rstan. May
    have been a failure in the rstan install, so ran in R

    <verbatim|install.packages("rstan", dependencies = TRUE)>

    Still not finding headers

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        library(brms)

        Table5.7.brms \<less\>- brm(obs ~ 0 + trt + (1 \| rep),
        data=Table5.7)
      <|unfolded-io>
        library(brms)

        Loading required package: rstan

        Loading required package: StanHeaders

        rstan (Version 2.12.1, packaged: 2016-09-11 13:07:50 UTC, GitRev:
        85f7a56811da)

        For execution on a local, multicore CPU with excess RAM we recommend
        calling

        rstan_options(auto_write = TRUE)

        options(mc.cores = parallel::detectCores())

        \;

        Attaching package: 'rstan'

        \;

        The following object is masked from 'package:coda':

        \;

        \ \ \ \ traceplot

        \;

        Loading 'brms' package (version 0.10.0). Useful instructions\ 

        can be found by typing help('brms'). A more detailed introduction\ 

        to the package is available through vignette('brms').

        \;

        Attaching package: 'brms'

        \;

        The following objects are masked from 'package:glmmLasso':

        \;

        \ \ \ \ acat, cumulative

        \;

        The following object is masked from 'package:glmmADMB':

        \;

        \ \ \ \ VarCorr

        \;

        The following object is masked from 'package:survival':

        \;

        \ \ \ \ kidney

        \;

        \<gtr\> Table5.7.brms \<less\>- brm(obs ~ trt + (1 \| rep),
        data=Table5.7)

        Compiling the C++ model

        In file included from file51c74d5a26e7.cpp:8:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core.hpp:42:

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core/set_zero_all_adjoints.hpp:14:17:
        warning: unused function 'set_zero_all_adjoints' [-Wunused-function]

        \ \ \ \ static void set_zero_all_adjoints() {

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        In file included from file51c74d5a26e7.cpp:8:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core.hpp:43:

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core/set_zero_all_adjoints_nested.hpp:17:17:
        warning: 'static' function 'set_zero_all_adjoints_nested' declared in
        header file should be declared 'static inline'
        [-Wunneeded-internal-declaration]

        \ \ \ \ static void set_zero_all_adjoints_nested() {

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        In file included from file51c74d5a26e7.cpp:8:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:9:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat.hpp:54:

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat/fun/autocorrelation.hpp:17:14:
        warning: function 'fft_next_good_size' is not needed and will not be
        emitted [-Wunneeded-internal-declaration]

        \ \ \ \ \ \ size_t fft_next_good_size(size_t N) {

        \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        In file included from file51c74d5a26e7.cpp:8:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:9:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat.hpp:235:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/arr.hpp:36:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/arr/functor/integrate_ode_rk45.hpp:13:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/numeric/odeint.hpp:61:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/numeric/odeint/util/multi_array_adaption.hpp:29:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array.hpp:21:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/base.hpp:28:

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:42:43:
        warning: unused typedef 'index_range' [-Wunused-local-typedef]

        \ \ \ \ \ \ typedef typename Array::index_range index_range;

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:43:37:
        warning: unused typedef 'index' [-Wunused-local-typedef]

        \ \ \ \ \ \ typedef typename Array::index index;

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:53:43:
        warning: unused typedef 'index_range' [-Wunused-local-typedef]

        \ \ \ \ \ \ typedef typename Array::index_range index_range;

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:54:37:
        warning: unused typedef 'index' [-Wunused-local-typedef]

        \ \ \ \ \ \ typedef typename Array::index index;

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        7 warnings generated.

        \;

        SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 1).

        \;

        Chain 1, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

        Chain 1, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

        Chain 1, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

        Chain 1, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

        Chain 1, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

        Chain 1, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

        Chain 1, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

        Chain 1, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

        Chain 1, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

        Chain 1, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

        Chain 1, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

        Chain 1, Iteration: 2000 / 2000 [100%] \ (Sampling)

        \ Elapsed Time: 0.225854 seconds (Warm-up)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.185379 seconds (Sampling)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.411233 seconds (Total)

        \;

        \;

        SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 2).

        \;

        Chain 2, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

        Chain 2, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

        Chain 2, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

        Chain 2, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

        Chain 2, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

        Chain 2, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

        Chain 2, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

        Chain 2, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

        Chain 2, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

        Chain 2, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

        Chain 2, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

        Chain 2, Iteration: 2000 / 2000 [100%] \ (Sampling)

        \ Elapsed Time: 0.247109 seconds (Warm-up)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.166468 seconds (Sampling)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.413577 seconds (Total)

        \;

        \;

        SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 3).

        \;

        Chain 3, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

        Chain 3, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

        Chain 3, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

        Chain 3, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

        Chain 3, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

        Chain 3, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

        Chain 3, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

        Chain 3, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

        Chain 3, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

        Chain 3, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

        Chain 3, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

        Chain 3, Iteration: 2000 / 2000 [100%] \ (Sampling)

        \ Elapsed Time: 0.199763 seconds (Warm-up)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.194775 seconds (Sampling)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.394538 seconds (Total)

        \;

        \;

        SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 4).

        \;

        Chain 4, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

        Chain 4, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

        Chain 4, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

        Chain 4, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

        Chain 4, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

        Chain 4, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

        Chain 4, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

        Chain 4, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

        Chain 4, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

        Chain 4, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

        Chain 4, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

        Chain 4, Iteration: 2000 / 2000 [100%] \ (Sampling)

        \ Elapsed Time: 0.250374 seconds (Warm-up)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.208748 seconds (Sampling)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.459122 seconds (Total)

        \;

        Warning messages:

        1: There were 57 divergent transitions after warmup. Increasing
        adapt_delta above 0.8 may help. See

        http://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup\ 

        2: Examine the pairs() plot to diagnose sampling problems

        \ 
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Variances (Example 1)>

    <big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|Replicate>|<cell|>|<cell|Residual>|<cell|>>|<row|<cell|>|<cell|<math|\<sigma\><rsub|r><rsup|2>>>|<cell|<math|\<sigma\><rsub|r>>>|<cell|<math|\<sigma\><rsup|2>>>|<cell|<math|\<sigma\>>>>|<row|<cell|Expected>|<cell|1>|<cell|>|<cell|1>|<cell|>>|<row|<cell|Published>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lm>|<cell|?>|<cell|>|<cell|1.3146>|<cell|<with|font-shape|italic|1.14656>>>|<row|<cell|lme>|<cell|
    >|<cell|0.9438476>|<cell|<with|font-shape|italic|1.318483>>|<cell|1.148252>>|<row|<cell|glmmPQL>|<cell|0.6701158>|<cell|0.8186060>|<cell|0.9534090>|<cell|0.9764266>>|<row|<cell|lmer>|<cell|>|<cell|0.94384>|<cell|>|<cell|1.14825>>|<row|<cell|blmer>|<cell|2.335>|<cell|1.528>|<cell|1.168>|<cell|1.081>>|<row|<cell|glmmadmb>|<cell|0.97642>|<cell|>|<cell|0.6701>|<cell|0.8186>>|<row|<cell|lmm>|<cell|0.8908509>|<cell|>|<cell|1.3184829>|<cell|>>|<row|<cell|glmmLasso>|<cell|>|<cell|1.463278>|<cell|>|<cell|>>|<row|<cell|MCMCglmm>|<cell|8.547397e-05>|<cell|>|<cell|2.501073>|<cell|>>|<row|<cell|inla>|<cell|18590.8084>|<cell|>|<cell|0.5174>|<cell|>>|<row|<cell|brm>|<cell|>|<cell|1.65>|<cell|>|<cell|1.28>>>>>|>

    \;

    \;

    \ 

    \ \ \ \ \ \ \ \ \ \ \ \ \ 
  </hidden>|<\hidden>
    <tit|Plots (Example 1)>

    \;

    \;
  </hidden>|<\hidden>
    <tit|Combined Mean Plots >

    \;
  </hidden>|<\hidden>
    <tit|Example 2 lm>

    \;

    <\session|r|default>
      <\output>
        <script-interrupted>
      </output>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.lm \<less\>- lm(Yield ~ Trial:Rep + Trial*Variety,
        data=Ex16.8.1)

        summary(aov(Yield ~ Trial:Rep + Trial + Variety +
        Error(Trial:Variety), data=Ex16.8.1))

        summary(aov(Yield ~ Trial*Variety + Error(Trial:Rep), data=Ex16.8.1))
      <|unfolded-io>
        <script-interrupted>
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|Example 2, lme and glmmPQL>

    \;

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.lme \<less\>- lme(Yield ~ Variety*Trial, random = ~ 1 \|
        Trial:Rep, data=Ex16.8.1)
      <|unfolded-io>
        Ex16.8.1.lme \<less\>- lme(Yield ~ Variety*Trial, random = ~ 1 \|
        Trial:Rep, data=E

        \<less\> ~ Variety*Trial, random = ~ 1 \| Trial:Rep, data=Ex16.8.1)

        Error in getGroups.data.frame(dataMix, groups) :\ 

        \ \ invalid formula for groups
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1$Block \<less\>- Ex16.8.1$Trial:Ex16.8.1$Rep

        Ex16.8.1.lme \<less\>- lme(Yield ~ Variety*Trial, random = ~ 1 \|
        Block, data=Ex16.8.1)

        summary(Ex16.8.1.lme)
      <|unfolded-io>
        Ex16.8.1$Block \<less\>- Ex16.8.1$Trial:Ex16.8.1$Rep

        \<gtr\> Ex16.8.1.lme \<less\>- lme(Yield ~ Variety*Trial, random = ~
        1 \| Block, data=Ex16.

        \<less\> ~ Variety*Trial, random = ~ 1 \| Block, data=Ex16.8.1)

        \<gtr\> summary(Ex16.8.1.lme)

        Linear mixed-effects model fit by REML

        \ Data: Ex16.8.1\ 

        \ \ \ \ \ \ \ AIC \ \ \ \ \ BIC \ \ \ logLik

        \ \ 1029.339 1115.853 -476.6696

        \;

        Random effects:

        \ Formula: ~1 \| Block

        \ \ \ \ \ \ \ \ (Intercept) Residual

        StdDev: 0.008810791 137.9402

        \;

        Fixed effects: Yield ~ Variety * Trial\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Value
        Std.Error DF \ \ t-value p-value

        (Intercept) \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1200.6667 \ 79.63979
        66 15.076215 \ 0.0000

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -93.6667 112.62768 66
        -0.831649 \ 0.4086

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 249.6667 112.62768 66
        \ 2.216743 \ 0.0301

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -94.0000 112.62768 66
        -0.834608 \ 0.4069

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 127.0000 112.62768 66
        \ 1.127609 \ 0.2636

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 62.0000 112.62768 66
        \ 0.550486 \ 0.5838

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 74.0000 112.62768 66
        \ 0.657032 \ 0.5134

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 12.0000 112.62768 66
        \ 0.106546 \ 0.9155

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -26.6667 112.62768 66
        -0.236768 \ 0.8136

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -68.3333 112.62768 66
        -0.606719 \ 0.5461

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -100.3333 112.62768 66
        -0.890841 \ 0.3763

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -125.0000 112.62768 66
        -1.109852 \ 0.2711

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 391.0000 112.62768
        \ 6 \ 3.471616 \ 0.0133

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 191.3333 112.62768
        \ 6 \ 1.698813 \ 0.1403

        VarietyD74-7741:TrialClinton \ \ 232.6667 159.27959 66 \ 1.460744
        \ 0.1488

        VarietyN72-137:TrialClinton \ \ -300.0000 159.27959 66 -1.883480
        \ 0.0640

        VarietyN72-3058:TrialClinton \ \ 101.3333 159.27959 66 \ 0.636198
        \ 0.5268

        VarietyN72-3148:TrialClinton \ \ \ 65.3333 159.27959 66 \ 0.410180
        \ 0.6830

        VarietyN73-1102:TrialClinton \ \ \ 77.0000 159.27959 66 \ 0.483427
        \ 0.6304

        VarietyN73-693:TrialClinton \ \ \ -94.6667 159.27959 66 -0.594343
        \ 0.5543

        VarietyN73-877:TrialClinton \ \ \ \ 15.6667 159.27959 66 \ 0.098360
        \ 0.9219

        VarietyN73-882:TrialClinton \ \ \ -41.6667 159.27959 66 -0.261595
        \ 0.7944

        VarietyR73-81:TrialClinton \ \ \ \ 179.0000 159.27959 66 \ 1.123810
        \ 0.2652

        VarietyR75-12:TrialClinton \ \ \ -105.6667 159.27959 66 -0.663404
        \ 0.5094

        VarietyTracy:TrialClinton \ \ \ \ \ 162.6667 159.27959 66 \ 1.021265
        \ 0.3109

        VarietyD74-7741:TrialPlymouth \ \ 83.3333 159.27959 66 \ 0.523189
        \ 0.6026

        VarietyN72-137:TrialPlymouth \ -181.6667 159.27959 66 -1.140552
        \ 0.2582

        VarietyN72-3058:TrialPlymouth \ -11.6667 159.27959 66 -0.073246
        \ 0.9418

        VarietyN72-3148:TrialPlymouth \ \ 67.3333 159.27959 66 \ 0.422737
        \ 0.6739

        VarietyN73-1102:TrialPlymouth \ \ 57.0000 159.27959 66 \ 0.357861
        \ 0.7216

        VarietyN73-693:TrialPlymouth \ \ \ -3.0000 159.27959 66 -0.018835
        \ 0.9850

        VarietyN73-877:TrialPlymouth \ \ -26.0000 159.27959 66 -0.163235
        \ 0.8708

        VarietyN73-882:TrialPlymouth \ \ 127.3333 159.27959 66 \ 0.799433
        \ 0.4269

        VarietyR73-81:TrialPlymouth \ \ \ -37.0000 159.27959 66 -0.232296
        \ 0.8170

        VarietyR75-12:TrialPlymouth \ \ -250.0000 159.27959 66 -1.569567
        \ 0.1213

        VarietyTracy:TrialPlymouth \ \ \ \ 137.6667 159.27959 66 \ 0.864308
        \ 0.3905

        \ Correlation:\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (Intr)
        VrD74-7741 VrN72-137 VrN72-3058

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyD74-7741:TrialClinton \ \ 0.500 -0.707 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ 0.500 -0.354 \ \ \ \ -0.707
        \ \ \ -0.354 \ \ \ 

        VarietyN72-3058:TrialClinton \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.707 \ \ \ 

        VarietyN72-3148:TrialClinton \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN73-1102:TrialClinton \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyD74-7741:TrialPlymouth \ 0.500 -0.707 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ 0.500 -0.354 \ \ \ \ -0.707
        \ \ \ -0.354 \ \ \ 

        VarietyN72-3058:TrialPlymouth \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.707 \ \ \ 

        VarietyN72-3148:TrialPlymouth \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VrN72-3148
        VrN73-1102 VrN73-693 VrN73-877

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        VarietyD74-7741:TrialClinton \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-137:TrialClinton \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-3058:TrialClinton \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-3148:TrialClinton \ -0.707 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN73-1102:TrialClinton \ -0.354 \ \ \ \ -0.707 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN73-693:TrialClinton \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.707
        \ \ \ -0.354 \ \ 

        VarietyN73-877:TrialClinton \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.707 \ \ 

        VarietyN73-882:TrialClinton \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyR73-81:TrialClinton \ \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyR75-12:TrialClinton \ \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyTracy:TrialClinton \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ \ -0.354 \ \ \ -0.354 \ \ 

        VarietyD74-7741:TrialPlymouth -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-137:TrialPlymouth \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-3058:TrialPlymouth -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-3148:TrialPlymouth -0.707 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VrN73-882
        VrR73-81 VrR75-12 VrtyTr TrlCln

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ 0.500
        \ \ \ 0.500 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ 0.500
        \ \ \ 0.500 \ \ \ 0.500 \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ 0.500
        \ \ \ 0.500 \ \ \ 0.500 \ 0.500

        VarietyD74-7741:TrialClinton \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN72-137:TrialClinton \ \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN72-3058:TrialClinton \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN72-3148:TrialClinton \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN73-1102:TrialClinton \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN73-693:TrialClinton \ \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN73-877:TrialClinton \ \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN73-882:TrialClinton \ \ -0.707 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyR73-81:TrialClinton \ \ \ -0.354 \ \ \ -0.707 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyR75-12:TrialClinton \ \ \ -0.354 \ \ \ -0.354 \ \ -0.707
        \ \ -0.354 -0.707

        VarietyTracy:TrialClinton \ \ \ \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.707 -0.707

        VarietyD74-7741:TrialPlymouth -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.354

        VarietyN72-137:TrialPlymouth \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.354

        VarietyN72-3058:TrialPlymouth -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.354

        VarietyN72-3148:TrialPlymouth -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.354

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TrlPly
        VD74-7741:TC VN72-137:TC VN72-3058:TC

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ -0.354
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ -0.354 \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyD74-7741:TrialPlymouth -0.707 \ 0.500 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 

        VarietyN72-137:TrialPlymouth \ -0.707 \ 0.250 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 

        VarietyN72-3058:TrialPlymouth -0.707 \ 0.250 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyN72-3148:TrialPlymouth -0.707 \ 0.250 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VN72-3148:TC
        VN73-1102:TC VN73-693:TC

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ 0.500 \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ 0.500 \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ 0.500 \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ 0.500 \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ 0.500 \ \ \ \ 

        VarietyD74-7741:TrialPlymouth \ 0.250 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ \ 0.250 \ \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ 0.250 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ \ 0.250 \ \ \ \ 

        VarietyN72-3058:TrialPlymouth \ 0.250 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ \ 0.250 \ \ \ \ 

        VarietyN72-3148:TrialPlymouth \ 0.500 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ \ 0.250 \ \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VN73-877:TC
        VN73-882:TC VR73-81:TC VR75-12:TC

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        \;

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ 0.500 \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ 0.500 \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ 0.500 \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500 \ \ \ 

        VarietyD74-7741:TrialPlymouth \ 0.250 \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 0.250 \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ 0.250 \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 0.250 \ \ \ 

        VarietyN72-3058:TrialPlymouth \ 0.250 \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 0.250 \ \ \ 

        VarietyN72-3148:TrialPlymouth \ 0.250 \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 0.250 \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VrT:TC
        VD74-7741:TP VN72-137:TP VN72-3058:TP

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialPlymouth \ 0.250
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ 0.250 \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialPlymouth \ 0.250 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialPlymouth \ 0.250 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VN72-3148:TP
        VN73-1102:TP VN73-693:TP

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VN73-877:TP
        VN73-882:TP VR73-81:TP VR75-12:TP

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        \ [ reached getOption("max.print") -- omitted 7 rows ]

        \;

        Standardized Within-Group Residuals:

        \ \ \ \ \ \ \ \ Min \ \ \ \ \ \ \ \ \ Q1 \ \ \ \ \ \ \ \ Med
        \ \ \ \ \ \ \ \ \ Q3 \ \ \ \ \ \ \ \ Max\ 

        -1.98153541 -0.61983394 \ 0.03020634 \ 0.55700477 \ 2.01536651\ 

        \;

        Number of Observations: 108

        Number of Groups: 9\ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.glmmPQL \<less\>- glmmPQL(Yield ~ Variety*Trial, random = ~
        1 \| Block , family=gaussian, data = Ex16.8.1)

        summary(Ex16.8.1.glmmPQL)
      <|unfolded-io>
        Ex16.8.1.glmmPQL \<less\>- glmmPQL(Yield ~ Variety*Trial, random = ~
        1 \| Block , f

        \<less\>QL(Yield ~ Variety*Trial, random = ~ 1 \| Block ,
        family=gaussian, data = Ex1

        \<less\>random = ~ 1 \| Block , family=gaussian, data = Ex16.8.1)

        iteration 1

        \<gtr\> summary(Ex16.8.1.glmmPQL)

        Linear mixed-effects model fit by maximum likelihood

        \ Data: Ex16.8.1\ 

        \ \ AIC BIC logLik

        \ \ \ NA \ NA \ \ \ \ NA

        \;

        Random effects:

        \ Formula: ~1 \| Block

        \ \ \ \ \ \ \ \ (Intercept) Residual

        StdDev: 0.006608463 112.6277

        \;

        Variance function:

        \ Structure: fixed weights

        \ Formula: ~invwt\ 

        Fixed effects: Yield ~ Variety * Trial\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Value
        Std.Error DF \ \ t-value p-value

        (Intercept) \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1200.6667 \ 79.63979
        66 15.076215 \ 0.0000

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -93.6667 112.62768 66
        -0.831649 \ 0.4086

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 249.6667 112.62768 66
        \ 2.216743 \ 0.0301

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -94.0000 112.62768 66
        -0.834608 \ 0.4069

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 127.0000 112.62768 66
        \ 1.127609 \ 0.2636

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 62.0000 112.62768 66
        \ 0.550486 \ 0.5838

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 74.0000 112.62768 66
        \ 0.657032 \ 0.5134

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 12.0000 112.62768 66
        \ 0.106546 \ 0.9155

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -26.6667 112.62768 66
        -0.236768 \ 0.8136

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -68.3333 112.62768 66
        -0.606719 \ 0.5461

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -100.3333 112.62768 66
        -0.890841 \ 0.3763

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -125.0000 112.62768 66
        -1.109852 \ 0.2711

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 391.0000 112.62768
        \ 6 \ 3.471616 \ 0.0133

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 191.3333 112.62768
        \ 6 \ 1.698813 \ 0.1403

        VarietyD74-7741:TrialClinton \ \ 232.6667 159.27959 66 \ 1.460744
        \ 0.1488

        VarietyN72-137:TrialClinton \ \ -300.0000 159.27959 66 -1.883480
        \ 0.0640

        VarietyN72-3058:TrialClinton \ \ 101.3333 159.27959 66 \ 0.636198
        \ 0.5268

        VarietyN72-3148:TrialClinton \ \ \ 65.3333 159.27959 66 \ 0.410180
        \ 0.6830

        VarietyN73-1102:TrialClinton \ \ \ 77.0000 159.27959 66 \ 0.483427
        \ 0.6304

        VarietyN73-693:TrialClinton \ \ \ -94.6667 159.27959 66 -0.594343
        \ 0.5543

        VarietyN73-877:TrialClinton \ \ \ \ 15.6667 159.27959 66 \ 0.098360
        \ 0.9219

        VarietyN73-882:TrialClinton \ \ \ -41.6667 159.27959 66 -0.261595
        \ 0.7944

        VarietyR73-81:TrialClinton \ \ \ \ 179.0000 159.27959 66 \ 1.123810
        \ 0.2652

        VarietyR75-12:TrialClinton \ \ \ -105.6667 159.27959 66 -0.663404
        \ 0.5094

        VarietyTracy:TrialClinton \ \ \ \ \ 162.6667 159.27959 66 \ 1.021265
        \ 0.3109

        VarietyD74-7741:TrialPlymouth \ \ 83.3333 159.27959 66 \ 0.523189
        \ 0.6026

        VarietyN72-137:TrialPlymouth \ -181.6667 159.27959 66 -1.140552
        \ 0.2582

        VarietyN72-3058:TrialPlymouth \ -11.6667 159.27959 66 -0.073246
        \ 0.9418

        VarietyN72-3148:TrialPlymouth \ \ 67.3333 159.27959 66 \ 0.422737
        \ 0.6739

        VarietyN73-1102:TrialPlymouth \ \ 57.0000 159.27959 66 \ 0.357861
        \ 0.7216

        VarietyN73-693:TrialPlymouth \ \ \ -3.0000 159.27959 66 -0.018835
        \ 0.9850

        VarietyN73-877:TrialPlymouth \ \ -26.0000 159.27959 66 -0.163235
        \ 0.8708

        VarietyN73-882:TrialPlymouth \ \ 127.3333 159.27959 66 \ 0.799433
        \ 0.4269

        VarietyR73-81:TrialPlymouth \ \ \ -37.0000 159.27959 66 -0.232296
        \ 0.8170

        VarietyR75-12:TrialPlymouth \ \ -250.0000 159.27959 66 -1.569567
        \ 0.1213

        VarietyTracy:TrialPlymouth \ \ \ \ 137.6667 159.27959 66 \ 0.864308
        \ 0.3905

        \ Correlation:\ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ (Intr)
        VrD74-7741 VrN72-137 VrN72-3058

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ -0.707 \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ \ 

        VarietyD74-7741:TrialClinton \ \ 0.500 -0.707 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ 0.500 -0.354 \ \ \ \ -0.707
        \ \ \ -0.354 \ \ \ 

        VarietyN72-3058:TrialClinton \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.707 \ \ \ 

        VarietyN72-3148:TrialClinton \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN73-1102:TrialClinton \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyD74-7741:TrialPlymouth \ 0.500 -0.707 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ 0.500 -0.354 \ \ \ \ -0.707
        \ \ \ -0.354 \ \ \ 

        VarietyN72-3058:TrialPlymouth \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.707 \ \ \ 

        VarietyN72-3148:TrialPlymouth \ 0.500 -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VrN72-3148
        VrN73-1102 VrN73-693 VrN73-877

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500
        \ \ \ \ \ 0.500 \ \ \ \ 0.500 \ \ 

        VarietyD74-7741:TrialClinton \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-137:TrialClinton \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-3058:TrialClinton \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-3148:TrialClinton \ -0.707 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN73-1102:TrialClinton \ -0.354 \ \ \ \ -0.707 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN73-693:TrialClinton \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.707
        \ \ \ -0.354 \ \ 

        VarietyN73-877:TrialClinton \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.707 \ \ 

        VarietyN73-882:TrialClinton \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyR73-81:TrialClinton \ \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyR75-12:TrialClinton \ \ \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyTracy:TrialClinton \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ \ -0.354 \ \ \ -0.354 \ \ 

        VarietyD74-7741:TrialPlymouth -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-137:TrialPlymouth \ -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-3058:TrialPlymouth -0.354 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        VarietyN72-3148:TrialPlymouth -0.707 \ \ \ \ -0.354 \ \ \ \ -0.354
        \ \ \ -0.354 \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VrN73-882
        VrR73-81 VrR75-12 VrtyTr TrlCln

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ 0.500
        \ \ \ 0.500 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ 0.500
        \ \ \ 0.500 \ \ \ 0.500 \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 0.500 \ \ \ \ 0.500
        \ \ \ 0.500 \ \ \ 0.500 \ 0.500

        VarietyD74-7741:TrialClinton \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN72-137:TrialClinton \ \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN72-3058:TrialClinton \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN72-3148:TrialClinton \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN73-1102:TrialClinton \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN73-693:TrialClinton \ \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN73-877:TrialClinton \ \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyN73-882:TrialClinton \ \ -0.707 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyR73-81:TrialClinton \ \ \ -0.354 \ \ \ -0.707 \ \ -0.354
        \ \ -0.354 -0.707

        VarietyR75-12:TrialClinton \ \ \ -0.354 \ \ \ -0.354 \ \ -0.707
        \ \ -0.354 -0.707

        VarietyTracy:TrialClinton \ \ \ \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.707 -0.707

        VarietyD74-7741:TrialPlymouth -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.354

        VarietyN72-137:TrialPlymouth \ -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.354

        VarietyN72-3058:TrialPlymouth -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.354

        VarietyN72-3148:TrialPlymouth -0.354 \ \ \ -0.354 \ \ -0.354
        \ \ -0.354 -0.354

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ TrlPly
        VD74-7741:TC VN72-137:TC VN72-3058:TC

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ -0.354
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ -0.354 \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ -0.354 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyD74-7741:TrialPlymouth -0.707 \ 0.500 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 

        VarietyN72-137:TrialPlymouth \ -0.707 \ 0.250 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 

        VarietyN72-3058:TrialPlymouth -0.707 \ 0.250 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        VarietyN72-3148:TrialPlymouth -0.707 \ 0.250 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VN72-3148:TC
        VN73-1102:TC VN73-693:TC

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ 0.500 \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ 0.500 \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ 0.500 \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ 0.500 \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ 0.500 \ \ \ \ 

        VarietyD74-7741:TrialPlymouth \ 0.250 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ \ 0.250 \ \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ 0.250 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ \ 0.250 \ \ \ \ 

        VarietyN72-3058:TrialPlymouth \ 0.250 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ \ 0.250 \ \ \ \ 

        VarietyN72-3148:TrialPlymouth \ 0.500 \ \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ \ 0.250 \ \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VN73-877:TC
        VN73-882:TC VR73-81:TC VR75-12:TC

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ 0.500 \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ 0.500 \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ 0.500 \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 0.500 \ \ \ 

        VarietyD74-7741:TrialPlymouth \ 0.250 \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 0.250 \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ 0.250 \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 0.250 \ \ \ 

        VarietyN72-3058:TrialPlymouth \ 0.250 \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 0.250 \ \ \ 

        VarietyN72-3148:TrialPlymouth \ 0.250 \ \ \ \ \ \ 0.250
        \ \ \ \ \ \ 0.250 \ \ \ \ \ 0.250 \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VrT:TC
        VD74-7741:TP VN72-137:TP VN72-3058:TP

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialPlymouth \ 0.250
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ 0.250 \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialPlymouth \ 0.250 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialPlymouth \ 0.250 \ 0.500 \ \ \ \ \ \ \ 0.500
        \ \ \ \ \ \ 0.500 \ \ \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VN72-3148:TP
        VN73-1102:TP VN73-693:TP

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ VN73-877:TP
        VN73-882:TP VR73-81:TP VR75-12:TP

        VarietyD74-7741 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12 \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-1102:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-693:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-877:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN73-882:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR73-81:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyR75-12:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyTracy:TrialClinton \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyD74-7741:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-137:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3058:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        VarietyN72-3148:TrialPlymouth \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 

        \ [ reached getOption("max.print") -- omitted 7 rows ]

        \;

        Standardized Within-Group Residuals:

        \ \ \ \ \ \ \ \ Min \ \ \ \ \ \ \ \ \ Q1 \ \ \ \ \ \ \ \ Med
        \ \ \ \ \ \ \ \ \ Q3 \ \ \ \ \ \ \ \ Max\ 

        -2.42687533 -0.75913844 \ 0.03699506 \ 0.68218874 \ 2.46830980\ 

        \;

        Number of Observations: 108

        Number of Groups: 9\ 
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>

      <\textput>
        lme(Yield ~ Variety*Trial, random = ~ 1 \| Trial/Rep, data=Ex16.8.1)
        will run , but reports an error ind df
      </textput>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|Example 2, lmer, blmer and glmmadmb>

    \;

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.lmer \<less\>- lmer(Yield ~ 0 + Variety + (1 \| Trial/Rep) +
        (1 \| Trial:Variety), data=Ex16.8.1)
      <|unfolded-io>
        Ex16.8.1.lmer \<less\>- lmer(Yield ~ 0 + Variety + (1 \| Trial/Rep) +
        (1 \| Trial:Va

        \<less\>ld ~ 0 + Variety + (1 \| Trial/Rep) + (1 \| Trial:Variety),
        data=Ex16.8.1)
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.blmer \<less\>- blmer(Yield ~ 0 + Variety + (1 \| Trial/Rep)
        + (1 \| Trial:Variety), data=Ex16.8.1)
      <|unfolded-io>
        Ex16.8.1.blmer \<less\>- blmer(Yield ~ 0 + Variety + (1 \| Trial/Rep)
        + (1 \| Trial:

        \<less\>ield ~ 0 + Variety + (1 \| Trial/Rep) + (1 \| Trial:Variety),
        data=Ex16.8.1)

        Warning message:

        In get("checkConv", lme4Namespace)(attr(opt, "derivs"), opt$par, \ :

        \ \ Model failed to converge with max\|grad\| = 1.1541 (tol = 0.002,
        component 1)
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.blmer \<less\>- blmer(Yield ~ 0 + Variety + (1 \| Trial/Rep)
        + (1 \| Trial:Variety), data=Ex16.8.1,cov.prior=NULL)
      <|unfolded-io>
        Ex16.8.1.blmer \<less\>- blmer(Yield ~ 0 + Variety + (1 \| Trial/Rep)
        + (1 \| Trial:

        \<less\>ield ~ 0 + Variety + (1 \| Trial/Rep) + (1 \| Trial:Variety),
        data=Ex16.8.1,co

        \<less\>Trial/Rep) + (1 \| Trial:Variety),
        data=Ex16.8.1,cov.prior=NULL)
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.admb \<less\>- glmmadmb(Yield ~ 0+Variety, random = ~ (1 \|
        Trial/Rep) + (1 \| Trial:Variety), family = "gaussian", data =
        Ex16.8.1)
      <|unfolded-io>
        Ex16.8.1.admb \<less\>- glmmadmb(Yield ~ 0+Variety, random = ~ (1 \|
        Trial/Rep) + (

        \<less\>(Yield ~ 0+Variety, random = ~ (1 \| Trial/Rep) + (1 \|
        Trial:Variety), family

        \<less\> = ~ (1 \| Trial/Rep) + (1 \| Trial:Variety), family =
        "gaussian", data = Ex16

        \<less\>\| Trial:Variety), family = "gaussian", data = Ex16.8.1)

        Warning message:

        In eval(expr, envir, enclos) : sd.est not defined for this family
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|Summary>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        print(summary(Ex16.8.1.lmer), correlation = FALSE)
      <|unfolded-io>
        print(summary(Ex16.8.1.lmer), correlation = FALSE)

        Linear mixed model fit by REML ['lmerMod']

        Formula: Yield ~ 0 + Variety + (1 \| Trial/Rep) + (1 \|
        Trial:Variety)

        \ \ \ Data: Ex16.8.1

        \;

        REML criterion at convergence: 1258.9

        \;

        Scaled residuals:\ 

        \ \ \ \ \ Min \ \ \ \ \ \ 1Q \ \ Median \ \ \ \ \ \ 3Q \ \ \ \ \ Max\ 

        -2.12253 -0.63928 -0.09011 \ 0.61714 \ 2.91352\ 

        \;

        Random effects:

        \ Groups \ \ \ \ \ \ \ Name \ \ \ \ \ \ \ Variance Std.Dev.

        \ Trial:Variety (Intercept) \ 1732 \ \ \ \ 41.61 \ 

        \ Rep:Trial \ \ \ \ (Intercept) \ \ \ \ 0 \ \ \ \ \ 0.00 \ 

        \ Trial \ \ \ \ \ \ \ \ (Intercept) 42572 \ \ \ 206.33 \ 

        \ Residual \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 19027 \ \ \ 137.94 \ 

        Number of obs: 108, groups: \ Trial:Variety, 36; Rep:Trial, 9; Trial,
        3

        \;

        Fixed effects:

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error t value

        VarietyCentennial \ \ 1394.8 \ \ \ \ \ 129.9 \ \ 10.73

        VarietyD74-7741 \ \ \ \ 1406.4 \ \ \ \ \ 129.9 \ \ 10.82

        VarietyN72-137 \ \ \ \ \ 1483.9 \ \ \ \ \ 129.9 \ \ 11.42

        VarietyN72-3058 \ \ \ \ 1330.7 \ \ \ \ \ 129.9 \ \ 10.24

        VarietyN72-3148 \ \ \ \ 1566.0 \ \ \ \ \ 129.9 \ \ 12.05

        VarietyN73-1102 \ \ \ \ 1501.4 \ \ \ \ \ 129.9 \ \ 11.56

        VarietyN73-693 \ \ \ \ \ 1436.2 \ \ \ \ \ 129.9 \ \ 11.05

        VarietyN73-877 \ \ \ \ \ 1403.3 \ \ \ \ \ 129.9 \ \ 10.80

        VarietyN73-882 \ \ \ \ \ 1396.7 \ \ \ \ \ 129.9 \ \ 10.75

        VarietyR73-81 \ \ \ \ \ \ 1373.8 \ \ \ \ \ 129.9 \ \ 10.57

        VarietyR75-12 \ \ \ \ \ \ 1175.9 \ \ \ \ \ 129.9 \ \ \ 9.05

        VarietyTracy \ \ \ \ \ \ \ 1369.9 \ \ \ \ \ 129.9 \ \ 10.54
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        print(summary(Ex16.8.1.blmer), correlation = FALSE)
      <|unfolded-io>
        print(summary(Ex16.8.1.blmer), correlation = FALSE)

        Prior dev \ : 0

        \;

        Linear mixed model fit by REML ['blmerMod']

        Formula: Yield ~ 0 + Variety + (1 \| Trial/Rep) + (1 \|
        Trial:Variety)

        \ \ \ Data: Ex16.8.1

        \;

        REML criterion at convergence: 1258.9

        \;

        Scaled residuals:\ 

        \ \ \ \ \ Min \ \ \ \ \ \ 1Q \ \ Median \ \ \ \ \ \ 3Q \ \ \ \ \ Max\ 

        -2.12253 -0.63928 -0.09011 \ 0.61714 \ 2.91352\ 

        \;

        Random effects:

        \ Groups \ \ \ \ \ \ \ Name \ \ \ \ \ \ \ Variance Std.Dev.

        \ Trial:Variety (Intercept) \ 1732 \ \ \ \ 41.61 \ 

        \ Rep:Trial \ \ \ \ (Intercept) \ \ \ \ 0 \ \ \ \ \ 0.00 \ 

        \ Trial \ \ \ \ \ \ \ \ (Intercept) 42572 \ \ \ 206.33 \ 

        \ Residual \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 19027 \ \ \ 137.94 \ 

        Number of obs: 108, groups: \ Trial:Variety, 36; Rep:Trial, 9; Trial,
        3

        \;

        Fixed effects:

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error t value

        VarietyCentennial \ \ 1394.8 \ \ \ \ \ 129.9 \ \ 10.73

        VarietyD74-7741 \ \ \ \ 1406.4 \ \ \ \ \ 129.9 \ \ 10.82

        VarietyN72-137 \ \ \ \ \ 1483.9 \ \ \ \ \ 129.9 \ \ 11.42

        VarietyN72-3058 \ \ \ \ 1330.7 \ \ \ \ \ 129.9 \ \ 10.24

        VarietyN72-3148 \ \ \ \ 1566.0 \ \ \ \ \ 129.9 \ \ 12.05

        VarietyN73-1102 \ \ \ \ 1501.4 \ \ \ \ \ 129.9 \ \ 11.56

        VarietyN73-693 \ \ \ \ \ 1436.2 \ \ \ \ \ 129.9 \ \ 11.05

        VarietyN73-877 \ \ \ \ \ 1403.3 \ \ \ \ \ 129.9 \ \ 10.80

        VarietyN73-882 \ \ \ \ \ 1396.7 \ \ \ \ \ 129.9 \ \ 10.75

        VarietyR73-81 \ \ \ \ \ \ 1373.8 \ \ \ \ \ 129.9 \ \ 10.57

        VarietyR75-12 \ \ \ \ \ \ 1175.9 \ \ \ \ \ 129.9 \ \ \ 9.05

        VarietyTracy \ \ \ \ \ \ \ 1369.9 \ \ \ \ \ 129.9 \ \ 10.54
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        print(summary(Ex16.8.1.admb), correlation = FALSE)
      <|unfolded-io>
        print(summary(Ex16.8.1.admb), correlation = FALSE)

        \;

        Call:

        glmmadmb(formula = Yield ~ 0 + Variety, data = Ex16.8.1, family =
        "gaussian",\ 

        \ \ \ \ random = ~(1 \| Trial/Rep) + (1 \| Trial:Variety))

        \;

        AIC: 1409.6\ 

        \;

        Coefficients:

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate Std. Error z value
        Pr(\<gtr\>\|z\|) \ \ \ 

        VarietyCentennial \ \ \ \ 1395 \ \ \ \ \ \ \ 107 \ \ \ 13.0
        \ \ \<less\>2e-16 ***

        VarietyD74-7741 \ \ \ \ \ \ 1406 \ \ \ \ \ \ \ 107 \ \ \ 13.1
        \ \ \<less\>2e-16 ***

        VarietyN72-137 \ \ \ \ \ \ \ 1484 \ \ \ \ \ \ \ 107 \ \ \ 13.9
        \ \ \<less\>2e-16 ***

        VarietyN72-3058 \ \ \ \ \ \ 1331 \ \ \ \ \ \ \ 107 \ \ \ 12.4
        \ \ \<less\>2e-16 ***

        VarietyN72-3148 \ \ \ \ \ \ 1566 \ \ \ \ \ \ \ 107 \ \ \ 14.6
        \ \ \<less\>2e-16 ***

        VarietyN73-1102 \ \ \ \ \ \ 1502 \ \ \ \ \ \ \ 107 \ \ \ 14.0
        \ \ \<less\>2e-16 ***

        VarietyN73-693 \ \ \ \ \ \ \ 1436 \ \ \ \ \ \ \ 107 \ \ \ 13.4
        \ \ \<less\>2e-16 ***

        VarietyN73-877 \ \ \ \ \ \ \ 1403 \ \ \ \ \ \ \ 107 \ \ \ 13.1
        \ \ \<less\>2e-16 ***

        VarietyN73-882 \ \ \ \ \ \ \ 1397 \ \ \ \ \ \ \ 107 \ \ \ 13.0
        \ \ \<less\>2e-16 ***

        VarietyR73-81 \ \ \ \ \ \ \ \ 1374 \ \ \ \ \ \ \ 107 \ \ \ 12.8
        \ \ \<less\>2e-16 ***

        VarietyR75-12 \ \ \ \ \ \ \ \ 1176 \ \ \ \ \ \ \ 107 \ \ \ 11.0
        \ \ \<less\>2e-16 ***

        VarietyTracy \ \ \ \ \ \ \ \ \ 1370 \ \ \ \ \ \ \ 107 \ \ \ 12.8
        \ \ \<less\>2e-16 ***

        ---

        Signif. codes: \ 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

        \;

        \;

        Number of observations: total=108, Trial=3, Trial:Rep=9,
        Trial:Variety=36\ 

        Random effect variance(s):

        Group=Trial

        \ \ \ \ \ \ \ \ \ \ \ \ Variance StdDev

        (Intercept) \ \ \ 28356 \ 168.4

        Group=Trial:Rep

        \ \ \ \ \ \ \ \ \ \ \ \ Variance StdDev

        (Intercept) \ 0.01222 0.1105

        Group=Trial:Variety

        \ \ \ \ \ \ \ \ \ \ \ \ Variance StdDev

        (Intercept) \ \ 0.6992 0.8362

        \;

        Residual variance: 134.62 (std. err.: 9.2917)

        \;

        Log-likelihood: -688.783\ 

        Warning message:

        In .local(x, sigma, ...) :

        \ \ 'sigma' and 'rdig' arguments are present for compatibility only:
        ignored
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|glmmLasso>

    \;

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1$Interaction \<less\>- Ex16.8.1$Trial:Ex16.8.1$Variety

        Ex16.8.1.glmmLasso \<less\>- glmmLasso(fix = Yield ~ 0+Variety, rnd =
        list(Trial = ~1, Block = ~1,Interaction=~1), lambda = 200, data =
        Ex16.8.1,control=glmmLassoControl(center=FALSE))
      <|unfolded-io>
        Ex16.8.1$Interaction \<less\>- Ex16.8.1$Trial:Ex16.8.1$Variety

        \<gtr\> Ex16.8.1.glmmLasso \<less\>- glmmLasso(fix = Yield ~
        0+Variety, rnd = list(Trial =

        \<less\>mLasso(fix = Yield ~ 0+Variety, rnd = list(Trial = ~1, Block
        = ~1,Interactio

        \<less\>iety, rnd = list(Trial = ~1, Block = ~1,Interaction=~1),
        lambda = 200, data\ 

        \<less\>1, Block = ~1,Interaction=~1), lambda = 200, data =
        Ex16.8.1,control=glmmLas

        \<less\>~1), lambda = 200, data =
        Ex16.8.1,control=glmmLassoControl(center=FALSE))
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(Ex16.8.1.glmmLasso)
      <|unfolded-io>
        summary(Ex16.8.1.glmmLasso)

        Call:

        glmmLasso(fix = Yield ~ 0 + Variety, rnd = list(Trial = ~1, Block =
        ~1,\ 

        \ \ \ \ Interaction = ~1), data = Ex16.8.1, lambda = 200, control =
        glmmLassoControl(center = FALSE))

        \;

        \;

        Fixed Effects:

        \;

        Coefficients:

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate StdErr z.value p.value

        VarietyCentennial \ \ 761.66 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyD74-7741 \ \ \ \ 773.01 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN72-137 \ \ \ \ \ 848.36 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN72-3058 \ \ \ \ 699.28 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN72-3148 \ \ \ \ 928.25 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN73-1102 \ \ \ \ 865.44 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN73-693 \ \ \ \ \ 801.98 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN73-877 \ \ \ \ \ 769.98 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN73-882 \ \ \ \ \ 763.50 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyR73-81 \ \ \ \ \ \ 741.23 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyR75-12 \ \ \ \ \ \ 452.73 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyTracy \ \ \ \ \ \ \ 737.44 \ \ \ \ NA \ \ \ \ \ NA
        \ \ \ \ \ NA

        \;

        Random Effects:

        \;

        StdDev:

        [[1]]

        \ \ \ \ \ \ \ \ \ Trial

        Trial 581.4307

        \;

        [[2]]

        \ \ \ \ \ \ \ \ \ Block

        Block 191.6454

        \;

        [[3]]

        \ \ \ \ \ \ \ \ \ \ \ \ Interaction

        Interaction \ \ \ 87.70168

        \;
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.glmmLasso \<less\>- glmmLasso(fix = Yield ~ Variety, rnd =
        list(Trial = ~1, Block = ~1,Interaction=~1), lambda = 200, data =
        Ex16.8.1)
      <|unfolded-io>
        Ex16.8.1.glmmLasso \<less\>- glmmLasso(fix = Yield ~ Variety, rnd =
        list(Trial = ~

        \<less\>mLasso(fix = Yield ~ Variety, rnd = list(Trial = ~1, Block =
        ~1,Interaction=

        \<less\>ty, rnd = list(Trial = ~1, Block = ~1,Interaction=~1), lambda
        = 200, data =\ 

        \<less\> Block = ~1,Interaction=~1), lambda = 200, data = Ex16.8.1)
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(Ex16.8.1.glmmLasso)
      <|unfolded-io>
        summary(Ex16.8.1.glmmLasso)

        Call:

        glmmLasso(fix = Yield ~ Variety, rnd = list(Trial = ~1, Block = ~1,\ 

        \ \ \ \ Interaction = ~1), data = Ex16.8.1, lambda = 200)

        \;

        \;

        Fixed Effects:

        \;

        Coefficients:

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Estimate StdErr z.value p.value

        (Intercept) \ \ \ \ \ 943.1902 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyD74-7741 \ \ 11.2920 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN72-137 \ \ \ 90.0344 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN72-3058 \ -43.8268 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN72-3148 \ 168.2355 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN73-1102 \ \ 90.4167 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN73-693 \ \ \ 44.1086 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN73-877 \ \ \ -2.5376 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyN73-882 \ \ \ \ 8.5511 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyR73-81 \ \ \ -27.6137 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyR75-12 \ \ -201.6293 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        VarietyTracy \ \ \ \ \ -1.5268 \ \ \ \ NA \ \ \ \ \ NA \ \ \ \ \ NA

        \;

        Random Effects:

        \;

        StdDev:

        [[1]]

        \ \ \ \ \ \ \ \ Trial

        Trial 424.335

        \;

        [[2]]

        \ \ \ \ \ \ \ \ \ Block

        Block 141.2977

        \;

        [[3]]

        \ \ \ \ \ \ \ \ \ \ \ \ Interaction

        Interaction \ \ \ 79.23209

        \;
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|lmm>

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.minque \<less\>- lmm(Yield ~ Variety \| Trial/Rep +
        Variety:Trial, data=Ex16.8.1, method="reml")
      <|unfolded-io>
        Ex16.8.1.minque \<less\>- lmm(Yield ~ Variety \| Trial/Rep +
        Variety:Trial, data=Ex

        \<less\>eld ~ Variety \| Trial/Rep + Variety:Trial, data=Ex16.8.1,
        method="reml")
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.minque[[1]]$Var

        Ex16.8.1.minque[[1]]$FixedEffect
      <|unfolded-io>
        Ex16.8.1.minque[[1]]$Var

        $Yield

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Est
        \ \ \ \ \ \ \ \ SE \ \ \ \ \ \ Chi_sq \ \ \ \ \ P_value

        V(Trial) \ \ \ \ \ \ \ \ 42798.7637486 43473.3446 9.692066e-01
        1.624391e-01

        V(Trial:Rep) \ \ \ \ \ \ \ -0.6804343 \ \ 990.3605 4.720476e-07
        4.997259e-01

        V(Variety:Trial) \ 1504.9399551 \ 2689.6900 3.130645e-01 2.879029e-01

        V(e) \ \ \ \ \ \ \ \ \ \ \ \ 19707.9250842 \ 3430.7094 3.300000e+01
        4.607944e-09

        \;

        \<gtr\> Ex16.8.1.minque[[1]]$FixedEffect

        $Yield

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ Est
        \ \ \ \ \ \ SE \ \ \ \ z_value \ \ \ \ \ P_value

        mu \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1403.25000000 120.3767
        11.65715773 0.000000e+00

        Variety(Tracy) \ \ \ \ \ \ -33.36111111 \ 49.6703 -0.67165113
        5.018058e-01

        Variety(Centennial) \ \ -8.47222222 \ 49.6703 -0.17056919
        8.645625e-01

        Variety(N72-137) \ \ \ \ \ 80.63888889 \ 49.6703 \ 1.62348313
        1.044862e-01

        Variety(N72-3058) \ \ \ -72.58333333 \ 49.6703 -1.46130259
        1.439324e-01

        Variety(N72-3148) \ \ \ 162.75000000 \ 49.6703 \ 3.27660616
        1.050628e-03

        Variety(R73-81) \ \ \ \ \ -29.47222222 \ 49.6703 -0.59335708
        5.529422e-01

        Variety(D74-7741) \ \ \ \ \ 3.19444444 \ 49.6703 \ 0.06431297
        9.487210e-01

        Variety(N73-693) \ \ \ \ \ 32.97222222 \ 49.6703 \ 0.66382173
        5.068044e-01

        Variety(N73-877) \ \ \ \ \ \ 0.08333333 \ 49.6703 \ 0.00167773
        9.986614e-01

        Variety(N73-882) \ \ \ \ \ -6.58333333 \ 49.6703 -0.13254065
        8.945567e-01

        Variety(N73-1102) \ \ \ \ 98.19444444 \ 49.6703 \ 1.97692486
        4.805012e-02

        Variety(R75-12) \ \ \ \ -227.36111111 \ 49.6703 -4.57740594
        4.707774e-06

        \;
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>
  </hidden>|<\hidden>
    <tit|MCMCglmm>

    \;

    <\session|r|default>
      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.mcmc \<less\>- MCMCglmm(fixed=Yield ~ 0 + Variety, random =
        ~ Trial + \ Trial:Rep + Trial:Variety, data=Ex16.8.1, verbose=FALSE)
      <|unfolded-io>
        Ex16.8.1.mcmc \<less\>- MCMCglmm(fixed=Yield ~ 0 + Variety, random =
        ~ Trial + \ Tr

        \<less\>(fixed=Yield ~ 0 + Variety, random = ~ Trial + \ Trial:Rep +
        Trial:Variety, d

        \<less\>, random = ~ Trial + \ Trial:Rep + Trial:Variety,
        data=Ex16.8.1, verbose=FALS

        \<less\>l:Rep + Trial:Variety, data=Ex16.8.1, verbose=FALSE)
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.inla \<less\>- inla(Yield ~ 0 + Variety + f(Trial,
        model="iid") + f(Trial:Rep, model="iid") + f(Trial:Variety,
        model="iid"), data=Ex16.8.1)
      <|unfolded-io>
        Ex16.8.1.inla \<less\>- inla(Yield ~ 0 + Variety + f(Trial,
        model="iid") + f(Trial

        \<less\>ld ~ 0 + Variety + f(Trial, model="iid") + f(Trial:Rep,
        model="iid") + f(Tri

        \<less\>, model="iid") + f(Trial:Rep, model="iid") + f(Trial:Variety,
        model="iid"),\ 

        \<less\>ep, model="iid") + f(Trial:Variety, model="iid"),
        data=Ex16.8.1)
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        Ex16.8.1.brms \<less\>- brm(Yield ~ 0 + Variety + (1 \| Trial/Rep) +
        (1 \| Trial:Variety), data=Ex16.8.1)
      <|unfolded-io>
        Ex16.8.1.brms \<less\>- brm(Yield ~ 0 + Variety + (1 \| Trial/Rep) +
        (1 \| Trial:Var

        \<less\>d ~ 0 + Variety + (1 \| Trial/Rep) + (1 \| Trial:Variety),
        data=Ex16.8.1)

        Compiling the C++ model

        In file included from file51c779dc10e8.cpp:8:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core.hpp:42:

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core/set_zero_all_adjoints.hpp:14:17:
        warning: unused function 'set_zero_all_adjoints' [-Wunused-function]

        \ \ \ \ static void set_zero_all_adjoints() {

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        In file included from file51c779dc10e8.cpp:8:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core.hpp:43:

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/core/set_zero_all_adjoints_nested.hpp:17:17:
        warning: 'static' function 'set_zero_all_adjoints_nested' declared in
        header file should be declared 'static inline'
        [-Wunneeded-internal-declaration]

        \ \ \ \ static void set_zero_all_adjoints_nested() {

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        In file included from file51c779dc10e8.cpp:8:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:9:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat.hpp:54:

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat/fun/autocorrelation.hpp:17:14:
        warning: function 'fft_next_good_size' is not needed and will not be
        emitted [-Wunneeded-internal-declaration]

        \ \ \ \ \ \ size_t fft_next_good_size(size_t N) {

        \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        In file included from file51c779dc10e8.cpp:8:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/src/stan/model/model_header.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math.hpp:4:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/rev/mat.hpp:9:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/mat.hpp:235:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/arr.hpp:36:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/StanHeaders/include/stan/math/prim/arr/functor/integrate_ode_rk45.hpp:13:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/numeric/odeint.hpp:61:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/numeric/odeint/util/multi_array_adaption.hpp:29:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array.hpp:21:

        In file included from /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/base.hpp:28:

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:42:43:
        warning: unused typedef 'index_range' [-Wunused-local-typedef]

        \ \ \ \ \ \ typedef typename Array::index_range index_range;

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:43:37:
        warning: unused typedef 'index' [-Wunused-local-typedef]

        \ \ \ \ \ \ typedef typename Array::index index;

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:53:43:
        warning: unused typedef 'index_range' [-Wunused-local-typedef]

        \ \ \ \ \ \ typedef typename Array::index_range index_range;

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        /Library/Frameworks/R.framework/Versions/3.3/Resources/library/BH/include/boost/multi_array/concept_checks.hpp:54:37:
        warning: unused typedef 'index' [-Wunused-local-typedef]

        \ \ \ \ \ \ typedef typename Array::index index;

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ ^

        7 warnings generated.

        \;

        SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 1).

        \;

        Chain 1, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

        Chain 1, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

        Chain 1, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

        Chain 1, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

        Chain 1, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

        Chain 1, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

        Chain 1, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

        Chain 1, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

        Chain 1, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

        Chain 1, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

        Chain 1, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

        Chain 1, Iteration: 2000 / 2000 [100%] \ (Sampling)

        \ Elapsed Time: 5.10975 seconds (Warm-up)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.40395 seconds (Sampling)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.5137 seconds (Total)

        \;

        \;

        SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 2).

        \;

        Chain 2, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

        Chain 2, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

        Chain 2, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

        Chain 2, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

        Chain 2, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

        Chain 2, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

        Chain 2, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

        Chain 2, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

        Chain 2, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

        Chain 2, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

        Chain 2, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

        Chain 2, Iteration: 2000 / 2000 [100%] \ (Sampling)

        \ Elapsed Time: 4.62893 seconds (Warm-up)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.16112 seconds (Sampling)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.79005 seconds (Total)

        \;

        \;

        SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 3).

        \;

        Chain 3, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

        Chain 3, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

        Chain 3, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

        Chain 3, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

        Chain 3, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

        Chain 3, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

        Chain 3, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

        Chain 3, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

        Chain 3, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

        Chain 3, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

        Chain 3, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

        Chain 3, Iteration: 2000 / 2000 [100%] \ (Sampling)

        \ Elapsed Time: 4.59603 seconds (Warm-up)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 1.55956 seconds (Sampling)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.15559 seconds (Total)

        \;

        \;

        SAMPLING FOR MODEL 'gaussian(identity) brms-model' NOW (CHAIN 4).

        \;

        Chain 4, Iteration: \ \ \ 1 / 2000 [ \ 0%] \ (Warmup)

        Chain 4, Iteration: \ 200 / 2000 [ 10%] \ (Warmup)

        Chain 4, Iteration: \ 400 / 2000 [ 20%] \ (Warmup)

        Chain 4, Iteration: \ 600 / 2000 [ 30%] \ (Warmup)

        Chain 4, Iteration: \ 800 / 2000 [ 40%] \ (Warmup)

        Chain 4, Iteration: 1000 / 2000 [ 50%] \ (Warmup)

        Chain 4, Iteration: 1001 / 2000 [ 50%] \ (Sampling)

        Chain 4, Iteration: 1200 / 2000 [ 60%] \ (Sampling)

        Chain 4, Iteration: 1400 / 2000 [ 70%] \ (Sampling)

        Chain 4, Iteration: 1600 / 2000 [ 80%] \ (Sampling)

        Chain 4, Iteration: 1800 / 2000 [ 90%] \ (Sampling)

        Chain 4, Iteration: 2000 / 2000 [100%] \ (Sampling)

        \ Elapsed Time: 4.73228 seconds (Warm-up)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 2.14629 seconds (Sampling)

        \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ 6.87857 seconds (Total)

        \;

        Warning messages:

        1: There were 30 divergent transitions after warmup. Increasing
        adapt_delta above 0.8 may help. See

        http://mc-stan.org/misc/warnings.html#divergent-transitions-after-warmup\ 

        2: Examine the pairs() plot to diagnose sampling problems

        \ 
      </unfolded-io>

      <\unfolded-io>
        <with|color|red|\<gtr\> >
      <|unfolded-io>
        summary(Ex16.8.1.mcmc)
      <|unfolded-io>
        summary(Ex16.8.1.mcmc)

        Error in summary(Ex16.8.1.mcmc) : object 'Ex16.8.1.mcmc' not found
      </unfolded-io>

      <\input>
        <with|color|red|\<gtr\> >
      <|input>
        \;
      </input>
    </session>

    \;
  </hidden>|<\hidden>
    <tit|Variances (Example 2)>

    <big-table|<tabular|<tformat|<table|<row|<cell|>|<cell|Trial>|<cell|Interaction>|<cell|Block>|<cell|Residual>>|<row|<cell|>|<cell|<math|\<sigma\><rsub|e><rsup|2>>>|<cell|<math|\<sigma\><rsub|t
    \ \<times\>e>>>|<cell|<math|\<sigma\><rsub|r<around*|(|e|)>><rsup|2>>>|<cell|<math|\<sigma\><rsup|2>>>>|<row|<cell|lm>|<cell|>|<cell|>|<cell|>|<cell|19708>>|<row|<cell|lme>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmPQL>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|lmer>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|blmer>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|glmmadmb>|<cell|28356>|<cell|>|<cell|>|<cell|52255>>|<row|<cell|lmm>|<cell|>|<cell|>|<cell|>|<cell|19708>>|<row|<cell|glmmLasso>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|MCMCglmm>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|inla>|<cell|>|<cell|>|<cell|>|<cell|>>|<row|<cell|brm>|<cell|>|<cell|>|<cell|>|<cell|>>>>>|>

    \;

    \;

    \;

    \;
  </hidden>|<\hidden>
    <tit|>

    \;
  </hidden>>
</body>

<\references>
  <\collection>
    <associate|auto-1|<tuple|1|?>>
    <associate|auto-2|<tuple|2|?>>
    <associate|auto-3|<tuple|3|?>>
    <associate|auto-4|<tuple|4|?>>
    <associate|auto-5|<tuple|5|?>>
  </collection>
</references>

<\auxiliary>
  <\collection>
    <\associate|table>
      <tuple|normal||<pageref|auto-1>>

      <tuple|normal||<pageref|auto-2>>

      <tuple|normal||<pageref|auto-3>>

      <tuple|normal||<pageref|auto-4>>

      <tuple|normal||<pageref|auto-5>>
    </associate>
  </collection>
</auxiliary>