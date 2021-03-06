#This file generates serializeable structure definition macros that should be placed inside serializer.h
sub gen_def
{
my $x = $_[0];
my $init = $_[1];
my $i;
my $it = '';
my $it1 = "__SERIALIZER_DEFAULT<t", $it1tail = ">()";
$it = "_I" if $init;
$it1 = "i" if $init;
$it1tail = "" if $init;
	print F "#define DECLARE_SERIALIZEABLE_STRUC$x$it(strucname, t1, n1";
	print F ", i1" if $init;
	for ($i = 2; $i <= $x; $i++)
			{
				print F ", t$i, n$i";
				print F ", i$i" if $init;
			}
	print F ") \\\
		struct strucname : public _SerializableStructBase \\\
		{ \\\n";
	for ($i = 1; $i <= $x; $i++)
		{print F "            t$i n$i; \\\n";}
	print F "	\\
	            strucname(t1 n1 ## _";
	for ($i = 2; $i <= $x; $i++)
			{print F ", t$i n$i ## _";}
	print F ") : \\\n                n1(n1 ## _)";
	for ($i = 2; $i <= $x; $i++)
		{print F ", \\\n                n$i(n$i ## _)";}
	print F "\\\n	    {\\\
	            } \\\
	        \\\
	            strucname() : \\\n			n1(".$it1."1$it1tail)";
	for ($i = 2; $i <= $x; $i++)
		{print F ", \\\n			n$i($it1$i$it1tail)";}
	print F "\\\n		{ \\\
			} \\\n";
	print F "	\\\
		template <class _Ty>  inline BazisLib::ActionStatus __SERIALIZER_ITERATE_MEMBERS(_Ty &ref, bool Save) \\\
		{ \\\
			BazisLib::ActionStatus result;\\\n";
	for ($i = 1; $i <= $x; $i++)
		{print F "		if (!(result = ref._SerializerEntry(_T(#n$i), &n$i, Save)).Successful()) return result; \\\n";}
	print F "		return MAKE_STATUS(BazisLib::Success); \\\
		}\\\n};\\\n";
	print F "static inline const TCHAR * __SERIALIZER_GET_TYPE_NAME(strucname *ptr) {return _T(# strucname);}\n\n";
}

open F, ">ser_def.h";
print F "//This file was automatically generated by gen_ser.pl\n";
print F "//See serializer.h for details and comments\n\n";
for ($i = 1; $i <= 10; $i++)
{
	gen_def($i, 0);
}
for ($i = 1; $i <= 10; $i++)
{
	gen_def($i, 1);
}
close F;