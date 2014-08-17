--------------------------------------------------------------------------------------------------
------ This file is a copy of some part of PGF/Tikz.
------ It has been copied here to provide :
------  - compatibility with older PGF versions
------  - availability of PGF contributions by Christian Feuersaenger
------    which are necessary or helpful for pgfplots.
------
------ For reasons of simplicity, I have copied the whole file, including own contributions AND
------ PGF parts. The copyrights are as they appear in PGF.
------
------ Note that pgfplots has compatible licenses.
------ 
------ This copy has been modified in the following ways:
------  - nested \input commands have been updated
------  
--
-- Support for the contents of this file will NOT be done by the PGF/TikZ team. 
-- Please contact the author and/or maintainer of pgfplots (Christian Feuersaenger) if you need assistance in conjunction
-- with the deployment of this patch or partial content of PGF. Note that the author and/or maintainer of pgfplots has no obligation to fix anything:
-- This file comes without any warranty as the rest of pgfplots; there is no obligation for help.
----------------------------------------------------------------------------------------------------
-- Date of this copy: So 17. Aug 16:15:40 CEST 2014 ---



-- Copyright 2011 by Christophe Jorssen
--
-- This file may be distributed and/or modified
--
-- 1. under the LaTeX Project Public License and/or
-- 2. under the GNU Public License.
--
-- See the file doc/generic/pgf/licenses/LICENSE for more details.
--
-- $Id: pgfluamath.functions.lua,v 1.11 2014/08/16 14:48:20 cfeuersaenger Exp $
--

local pgfluamathfunctions = pgfluamathfunctions or {}

-- Maps function names to their function.
--
-- Note that this allows to register functions which are not in pgfluamathfunctions. 
--
-- Note that the string keys are not necessarily the same as the function
-- names. In particular, the math expression "not(1,1)" will execute notPGF(1,1) 
--
-- Note that each function which is added to pgfluamathfunctions will _automatically_ be inserted into this map, see __newindex.
-- (I fear it will not be erased directly...)
pgfluamathfunctions.stringToFunctionMap = {}

local newFunctionAllocatedCallback = function(table,key,value)
	local keyName = tostring(key):gsub("PGF","")
	if not value then
		stringToFunctionMap[keyName] = nil
	elseif type(value) == 'function' then
		-- remember it, and strip PGF suffix (i.e. remember 'not' instead of 'notPGF')
		pgfluamathfunctions.stringToFunctionMap[keyName] = value
	end
	rawset(table,key,value)
end

setmetatable(pgfluamathfunctions, { __newindex = newFunctionAllocatedCallback })

local mathabs, mathacos, mathasin = math.abs, math.acos, math.asin
local mathatan, mathatan2, mathceil = math.atan, math.atan2, math.ceil
local mathcos, mathcosh, mathdeg = math.cos, math.cosh, math.deg
local mathexp, mathfloor, mathfmod = math.exp, math.floor, math.fmod
local mathfrexp, mathhuge, mathldexp = math.frexp, math.huge, math.ldexp
local mathlog, mathlog10, mathmax = math.log, math.log10, math.max
local mathmin, mathmodf, mathpi = math.min, math.modf, math.pi
local mathpow, mathrad, mathrandom = math.pow, math.rad, math.random
local mathrandomseed, mathsin = math.randomseed, math.sin
local mathsinh, mathsqrt, mathtanh = math.sinh, math.sqrt, math.tanh
local mathtan = math.tan

local trigFormatToRadians = mathrad

local radiansToTrigFormat = mathdeg

pgfluamathfunctions.TrigFormat = { 'deg', 'rad' }
pgfluamathfunctions.stringToFunctionMap["TrigFormat"] = nil

-- choice is one of the valid choices in TrigFormat.
function pgfluamathfunctions.setTrigFormat(choice)
	if choice == 'deg' then
		trigFormatToRadians = mathrad
		radiansToTrigFormat = mathdeg
	elseif choice == 'rad' then
		local identity = function(x) return x end
		trigFormatToRadians = identity
		radiansToTrigFormat = identity
	else
		error("The argument '" .. tostring(choice) .. "' is no valid choice for setTrigFormat.")
	end
end
pgfluamathfunctions.stringToFunctionMap["setTrigFormat"] = nil

pgfluamathfunctions.setRandomSeed = mathrandomseed
pgfluamathfunctions.stringToFunctionMap["setRandomSeed"] = nil

-------------------------------------------

function pgfluamathfunctions.add(x,y)
   return x+y
end

function pgfluamathfunctions.substract(x,y)
   return x-y
end

function pgfluamathfunctions.neg(x)
   return -x
end

function pgfluamathfunctions.multiply(x,y)
   return x*y
end

function pgfluamathfunctions.divide(x,y)
   return x/y
end

function pgfluamathfunctions.pow(x,y)
   return mathpow(x,y)
end

function pgfluamathfunctions.factorial(x)
-- TODO: x must be an integer
   if x == 0 then
      return 1
   else
      return x * pgfluamathfunctions.factorial(x-1)
   end
end

function pgfluamathfunctions.ifthenelse(x,y,z)
   if x~= 0 then
      return y
   else
      return z
   end
end

function pgfluamathfunctions.equal(x,y)
   if x == y then
      return 1
   else
      return 0
   end
end

function pgfluamathfunctions.greater(x,y)
   if x > y then
      return 1
   else
      return 0
   end
end

function pgfluamathfunctions.less(x,y)
   if x < y then
      return 1
   else
      return 0
   end
end

function pgfluamathfunctions.notequal(x,y)
   if x ~= y then
      return 1
   else
      return 0
   end
end

function pgfluamathfunctions.notless(x,y)
   if x >= y then
      return 1
   else
      return 0
   end
end

function pgfluamathfunctions.notgreater(x,y)
   if x <= y then
      return 1
   else
      return 0
   end
end

function pgfluamathfunctions.andPGF(x,y)
   if (x ~= 0) and (y ~= 0) then
      return 1
   else
      return 0
   end
end

function pgfluamathfunctions.orPGF(x,y)
   if (x ~= 0) or (y ~= 0) then
      return 1
   else
      return 0
   end
end

function pgfluamathfunctions.notPGF(x)
   if x == 0 then
      return 1
   else
      return 0
   end
end

function pgfluamathfunctions.pi()
   return mathpi
end

function pgfluamathfunctions.e()
   return mathexp(1)
end

function pgfluamathfunctions.abs(x)
   return mathabs(x)
end

function pgfluamathfunctions.floor(x)
   return mathfloor(x)
end

function pgfluamathfunctions.ceil(x)
   return mathceil(x)
end

function pgfluamathfunctions.exp(x)
   return mathexp(x)
end

function pgfluamathfunctions.log(x)
   return mathlog(x)
end

function pgfluamathfunctions.log10(x)
   return mathlog10(x)
end

function pgfluamathfunctions.sqrt(x)
   return mathsqrt(x)
end

function pgfluamathfunctions.rnd()
   return mathrandom()
end

function pgfluamathfunctions.rand()
   return -1 + mathrandom() *2
end

function pgfluamathfunctions.random(x,y)
   if x == nil and y == nil then
      return mathrandom()
   elseif y == nil then
      return mathrandom(x)
   else
      return mathrandom(x,y)
   end
end

function pgfluamathfunctions.deg(x)
   return mathdeg(x)
end

function pgfluamathfunctions.rad(x)
   return mathrad(x)
end

function pgfluamathfunctions.round(x)
   if x<0 then
      return -mathceil(mathabs(x)) 
   else 
      return mathceil(x) 
   end
end

function pgfluamathfunctions.gcd(a, b)
   if b == 0 then
      return a
   else
      return gcd(b, a%b)
   end
end

function pgfluamathfunctions.isprime(a)
   local ifisprime = true
   if a == 1 then
      ifisprime = false
   elseif a == 2 then
      ifisprime = true
--   if a > 2 then
   else
      local i, imax = 2, mathceil(mathsqrt(a)) + 1
      while ifisprime and (i < imax) do
	 if gcd(a,i) ~= 1 then
	    ifisprime = false
	 end
	 i = i + 1
      end
   end
   if ifisprime then
      return 1
   else
      return 0
   end
end
      

function pgfluamathfunctions.split_braces_to_explist(s)
   -- (Thanks to mpg and zappathustra from fctt)
   -- Make unpack available whatever lua version is used 
   -- (unpack in lua 5.1 table.unpack in lua 5.2)
   local unpack = table.unpack or unpack
   local t = {}
   for i in s:gmatch('%b{}') do
      table.insert(t, tonumber(i:sub(2, -2)))
   end
   return unpack(t)
end

function pgfluamathfunctions.split_braces_to_table(s)
   local t = {}
   for i in s:gmatch('%b{}') do
      table.insert(t, tonumber(i:sub(2, -2)))
   end
   return t
end

function pgfluamathfunctions.mod(x,y)
   if x/y < 0 then
      return -(mathabs(x)%mathabs(y))
   else
      return mathabs(x)%mathabs(y)
   end
end

function pgfluamathfunctions.Mod(x,y)
   return mathabs(x)%mathabs(y)
end

function pgfluamathfunctions.Sin(x)
   return mathsin(trigFormatToRadians(x))
end
pgfluamathfunctions.sin=pgfluamathfunctions.Sin

function pgfluamathfunctions.Cos(x)
   return mathcos(trigFormatToRadians(x))
end
pgfluamathfunctions.cos=pgfluamathfunctions.Cos

function pgfluamathfunctions.Tan(x)
   return mathtan(trigFormatToRadians(x))
end
pgfluamathfunctions.tan=pgfluamathfunctions.Tan

function pgfluamathfunctions.aSin(x)
   return radiansToTrigFormat(mathasin(x))
end
pgfluamathfunctions.asin=pgfluamathfunctions.aSin

function pgfluamathfunctions.aCos(x)
   return radiansToTrigFormat(mathacos(x))
end
pgfluamathfunctions.acos=pgfluamathfunctions.aCos

function pgfluamathfunctions.aTan(x)
   return radiansToTrigFormat(mathatan(x))
end
pgfluamathfunctions.atan=pgfluamathfunctions.aTan

function pgfluamathfunctions.aTan2(y,x)
   return radiansToTrigFormat(mathatan2(y,x))
end
pgfluamathfunctions.atan2=pgfluamathfunctions.aTan2
pgfluamathfunctions.atantwo=pgfluamathfunctions.aTan2

function pgfluamathfunctions.cot(x)
	return pgfluamathfunctions.cos(x) / pgfluamathfunctions.sin(x)
end
function pgfluamathfunctions.sec(x)
	return 1 / pgfluamathfunctions.cos(x)
end
function pgfluamathfunctions.cosec(x)
	return 1 / pgfluamathfunctions.sin(x)
end

function pgfluamathfunctions.pointnormalised (pgfx, pgfy)
   local pgfx_normalised, pgfy_normalised
   if pgfx == 0. and pgfy == 0. then
      -- Orginal pgf macro gives this result
      tex.dimen['pgf@x'] = "0pt"
      tex.dimen['pgf@y'] = "1pt"
   else
      pgfx_normalised = pgfx/math.sqrt(pgfx^2 + pgfy^2)
      pgfx_normalised = pgfx_normalised - pgfx_normalised%0.00001
      pgfy_normalised = pgfy/math.sqrt(pgfx^2 + pgfy^2)
      pgfy_normalised = pgfy_normalised - pgfy_normalised%0.00001
      tex.dimen['pgf@x'] = tostring(pgfx_normalised) .. "pt"
      tex.dimen['pgf@y'] = tostring(pgfy_normalised) .. "pt"
   end
   return nil
end

local isnan = function(x)
    return x ~= x
end

pgfluamathfunctions.isnan = isnan

local infty = 1/0
pgfluamathfunctions.infty = infty

local nan = math.sqrt(-1)
pgfluamathfunctions.nan = nan

local stringlen = string.len
local globaltonumber = tonumber
local stringsub=string.sub
local stringformat = string.format
local stringsub = string.sub

-- like tonumber(x), but it also accepts nan, inf, infty, and the TeX FPU format
function pgfluamathfunctions.tonumber(x)
    if type(x) == 'number' then return x end
    if not x then return x end
    
    local len = stringlen(x)
    local result = globaltonumber(x)
    if not result then 
        if len >2 and stringsub(x,2,2) == 'Y' and stringsub(x,len,len) == ']' then
            -- Ah - some TeX FPU input of the form 1Y1.0e3] . OK. transform it
            local flag = stringsub(x,1,1)
            if flag == '0' then
                -- ah, 0.0
                result = 0.0
            elseif flag == '1' then
                result = globaltonumber(stringsub(x,3, len-1))
            elseif flag == '2' then
                result = globaltonumber("-" .. stringsub(x,3, len-1))
            elseif flag == '3' then
                result = nan
            elseif flag == '4' then
                result = infty
            elseif flag == '5' then
                result = -infty
            end
        else
            local lower = x:lower()
            if lower == 'nan' then 
                result = nan
            elseif lower == 'inf' or lower == 'infty' then 
                result = infty
            elseif lower == '-inf' or lower == '-infty' then 
                result = -infty 
            end
        end
    end    

    return result
end

-- a helper function which has no catcode issues when communicating with TeX:
function pgfluamathfunctions.tostringfixed(x)
    return stringformat("%f", x)
end

-- converts an input number to a string which is accepted by the TeX FPU
function pgfluamathfunctions.toTeXstring(x)
    local result = ""
    if x ~= nil then
        if x == infty then result = "4Y0.0e0]"
        elseif x == -infty then result = "5Y0.0e0]"
        elseif isnan(x) then result = "3Y0.0e0]"
        elseif x == 0 then result = "0Y0.0e0]"
        else
            -- FIXME : this is too long. But I do NOT want to loose digits!
            -- -> get rid of trailing zeros...
            result = stringformat("%.10e", x)
            if x > 0 then
                result = "1Y" .. result .. "]"
            else
                result = "2Y" .. stringsub(result,2) .. "]"
            end
        end
    end
    return result
end

return pgfluamathfunctions