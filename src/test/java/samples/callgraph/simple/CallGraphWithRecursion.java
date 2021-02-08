package samples.callgraph.simple;

/**
 * Quicksort and fibonacci
 *
 */
public class CallGraphWithRecursion {

	public void execute(int[] arr) {
		quickSort(arr, 0, arr.length - 1);
		System.out.println(fibonacci(10));
	}
	
	public static long fibonacci(final int n) {
		return (n < 2) ? n : fibonacci(n - 1) + fibonacci(n - 2);
	}
	
	void quickSort(int arr[], int low, int high) {
		if (low < high) {
			int partitionIndex = partition(arr, low, high);
			quickSort(arr, low, partitionIndex - 1);
			quickSort(arr, partitionIndex + 1, high);
		}
	}

	int partition(int arr[], int low, int high) {
		int pivot = arr[high];
		int i = (low - 1);
		for (int j = low; j < high; j++) {
			if (arr[j] <= pivot) {
				i++;
				int temp = arr[i];
				arr[i] = arr[j];
				arr[j] = temp;
			}
		}
		int temp = arr[i + 1];
		arr[i + 1] = arr[high];
		arr[high] = temp;
		return i + 1;
	}

//	public static void main(String[] args) {
//		CallGraphWithRecursion tmp = new CallGraphWithRecursion();
//
//		int array[] = { 10, 7, 8, 9, 1, 5 };
//		tmp.execute(array);	
//	}

}
